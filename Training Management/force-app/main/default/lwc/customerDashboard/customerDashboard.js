// customerDashboard.js
import { LightningElement, wire, track, api } from 'lwc';
import getCustomerEnrollments from '@salesforce/apex/TrainingController.getCustomerEnrollments';
import getCustomerCertificates from '@salesforce/apex/CertificateController.getCustomerCertificates';
import getUpcomingCourses from '@salesforce/apex/TrainingController.getUpcomingCourses';
import updateEnrollmentProgress from '@salesforce/apex/TrainingController.updateEnrollmentProgress';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class CustomerDashboard extends LightningElement {
    @api customerId; // Can be set from parent component or page
    @track selectedCustomerId = '';
    @track isLoading = false;
    @track activeTab = 'enrollments';
    @track showProgressModal = false;
    @track selectedEnrollment = {};
    @track progressValue = 0;

    // Wire results for refreshing
    wiredEnrollmentsResult;
    wiredCertificatesResult;
    wiredUpcomingCoursesResult;

    // Customer Enrollments
    @track enrollments = [];
    @wire(getCustomerEnrollments, { customerId: '$effectiveCustomerId' })
    wiredEnrollments(result) {
        this.wiredEnrollmentsResult = result;
        if (result.data) {
            this.enrollments = result.data.map(enrollment => ({
                ...enrollment,
                progressClass: this.getProgressClass(enrollment.Progress_Percentage__c),
                statusVariant: this.getStatusVariant(enrollment.Status__c),
                formattedEnrollmentDate: this.formatDate(enrollment.Enrollment_Date__c),
                formattedCompletionDate: this.formatDate(enrollment.Completion_Date__c),
                isInProgress: enrollment.Status__c === 'In Progress' || enrollment.Status__c === 'Enrolled',
                isCompleted: enrollment.Status__c === 'Completed'
            }));
        } else if (result.error) {
            this.showToast('Error', 'Error loading enrollments: ' + result.error.body.message, 'error');
        }
    }

    // Customer Certificates
    @track certificates = [];
    @wire(getCustomerCertificates, { customerId: '$effectiveCustomerId' })
    wiredCertificates(result) {
        this.wiredCertificatesResult = result;
        if (result.data) {
            this.certificates = result.data.map(cert => ({
                ...cert,
                formattedIssueDate: this.formatDate(cert.Issue_Date__c),
                formattedExpiryDate: this.formatDate(cert.Expiry_Date__c),
                statusVariant: this.getCertificateStatusVariant(cert.Status__c),
                isExpiringSoon: this.isExpiringSoon(cert.Expiry_Date__c),
                daysUntilExpiry: this.getDaysUntilExpiry(cert.Expiry_Date__c)
            }));
        } else if (result.error) {
            this.showToast('Error', 'Error loading certificates: ' + result.error.body.message, 'error');
        }
    }

    // Upcoming Courses
    @track upcomingCourses = [];
    @wire(getUpcomingCourses, { customerId: '$effectiveCustomerId' })
    wiredUpcomingCourses(result) {
        this.wiredUpcomingCoursesResult = result;
        if (result.data) {
            this.upcomingCourses = result.data.map(course => ({
                ...course,
                formattedStartDate: this.formatDate(course.Start_Date__c),
                formattedEndDate: this.formatDate(course.End_Date__c),
                daysUntilStart: this.getDaysUntilStart(course.Start_Date__c)
            }));
        } else if (result.error) {
            this.showToast('Error', 'Error loading upcoming courses: ' + result.error.body.message, 'error');
        }
    }

    // Computed property for effective customer ID
    get effectiveCustomerId() {
        return this.selectedCustomerId || this.customerId;
    }

    // Customer lookup change handler
    handleCustomerSelect(event) {
        this.selectedCustomerId = event.detail.recordId;
    }

    // Tab handlers
    handleTabActive(event) {
        this.activeTab = event.target.value;
    }

    // Progress update handlers
    handleUpdateProgress(event) {
        const enrollmentId = event.target.dataset.enrollmentId;
        this.selectedEnrollment = this.enrollments.find(enr => enr.Id === enrollmentId);
        this.progressValue = this.selectedEnrollment.Progress_Percentage__c || 0;
        this.showProgressModal = true;
    }

    handleProgressChange(event) {
        this.progressValue = event.target.value;
    }

    async handleSaveProgress() {
        this.isLoading = true;
        try {
            await updateEnrollmentProgress({
                enrollmentId: this.selectedEnrollment.Id,
                progressPercentage: this.progressValue
            });
            
            this.showToast('Success', 'Progress updated successfully!', 'success');
            this.closeProgressModal();
            
            // Refresh enrollments data
            await refreshApex(this.wiredEnrollmentsResult);
            
        } catch (error) {
            this.showToast('Error', 'Failed to update progress: ' + error.body.message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    closeProgressModal() {
        this.showProgressModal = false;
        this.selectedEnrollment = {};
        this.progressValue = 0;
    }

    // Statistics calculations
    get enrollmentStats() {
        const total = this.enrollments.length;
        const completed = this.enrollments.filter(e => e.Status__c === 'Completed').length;
        const inProgress = this.enrollments.filter(e => e.Status__c === 'In Progress' || e.Status__c === 'Enrolled').length;
        const cancelled = this.enrollments.filter(e => e.Status__c === 'Cancelled').length;
        
        return {
            total,
            completed,
            inProgress,
            cancelled,
            completionRate: total > 0 ? Math.round((completed / total) * 100) : 0
        };
    }

    get certificateStats() {
        const total = this.certificates.length;
        const valid = this.certificates.filter(c => c.Status__c === 'Valid').length;
        const expiringSoon = this.certificates.filter(c => this.isExpiringSoon(c.Expiry_Date__c)).length;
        
        return {
            total,
            valid,
            expiringSoon
        };
    }

    // Chart data for progress visualization
    get progressChartData() {
        const stats = this.enrollmentStats;
        return [
            { label: 'Completed', value: stats.completed, color: '#4bca81' },
            { label: 'In Progress', value: stats.inProgress, color: '#1589ee' },
            { label: 'Cancelled', value: stats.cancelled, color: '#fe9339' }
        ];
    }

    // Utility methods
    getProgressClass(progress) {
        if (!progress) return 'slds-progress-bar__value progress-low';
        if (progress < 30) return 'slds-progress-bar__value progress-low';
        if (progress < 70) return 'slds-progress-bar__value progress-medium';
        return 'slds-progress-bar__value progress-high';
    }

    getStatusVariant(status) {
        const variants = {
            'Enrolled': 'base',
            'In Progress': 'brand',
            'Completed': 'success',
            'Cancelled': 'error'
        };
        return variants[status] || 'base';
    }

    getCertificateStatusVariant(status) {
        const variants = {
            'Valid': 'success',
            'Expired': 'error',
            'Revoked': 'error'
        };
        return variants[status] || 'base';
    }

    formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', { 
            year: 'numeric', 
            month: 'short', 
            day: 'numeric' 
        });
    }

    isExpiringSoon(expiryDate) {
        if (!expiryDate) return false;
        const expiry = new Date(expiryDate);
        const today = new Date();
        const diffTime = expiry - today;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays <= 30 && diffDays > 0;
    }

    getDaysUntilExpiry(expiryDate) {
        if (!expiryDate) return '';
        const expiry = new Date(expiryDate);
        const today = new Date();
        const diffTime = expiry - today;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        
        if (diffDays < 0) return 'Expired';
        if (diffDays === 0) return 'Expires today';
        if (diffDays === 1) return 'Expires tomorrow';
        return `${diffDays} days left`;
    }

    getDaysUntilStart(startDate) {
        if (!startDate) return '';
        const start = new Date(startDate);
        const today = new Date();
        const diffTime = start - today;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        
        if (diffDays < 0) return 'Started';
        if (diffDays === 0) return 'Starts today';
        if (diffDays === 1) return 'Starts tomorrow';
        return `Starts in ${diffDays} days`;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    // Computed properties for conditional rendering
    get hasEnrollments() {
        return this.enrollments && this.enrollments.length > 0;
    }

    get hasCertificates() {
        return this.certificates && this.certificates.length > 0;
    }

    get hasUpcomingCourses() {
        return this.upcomingCourses && this.upcomingCourses.length > 0;
    }

    get hasData() {
        return this.effectiveCustomerId && (this.hasEnrollments || this.hasCertificates || this.hasUpcomingCourses);
    }

    get showCustomerSelector() {
        return !this.customerId; // Show selector only if customerId is not provided
    }
}