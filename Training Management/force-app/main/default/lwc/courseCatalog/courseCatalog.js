import { LightningElement, wire, track } from 'lwc';
import getActiveCourses from '@salesforce/apex/TrainingController.getActiveCourses';
import enrollCustomerInCourse from '@salesforce/apex/TrainingController.enrollCustomerInCourse';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class CourseCatalog extends LightningElement {
    @track courses = [];
    @track filteredCourses = [];
    @track searchTerm = '';
    @track selectedCategory = '';
    @track showEnrollmentModal = false;
    @track selectedCourseId = null;

    wiredCoursesResult;
    @wire(getActiveCourses)
    wiredCourses(result) {
        this.wiredCoursesResult = result;
        if (result.data) {
            this.courses = result.data;
            this.filteredCourses = result.data;
        }
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value.toLowerCase();
        this.filterCourses();
    }

    handleCategoryChange(event) {
        this.selectedCategory = event.detail.value;
        this.filterCourses();
    }

    filterCourses() {
        this.filteredCourses = this.courses.filter(course => {
            const matchesSearch = !this.searchTerm ||
                course.Name.toLowerCase().includes(this.searchTerm) ||
                (course.Description__c && course.Description__c.toLowerCase().includes(this.searchTerm));

            const matchesCategory = !this.selectedCategory || course.Category__c === this.selectedCategory;
            return matchesSearch && matchesCategory;
        });
    }

    handleEnrollClick(event) {
        this.selectedCourseId = event.target.dataset.courseId;
        this.showEnrollmentModal = true;
    }

    handleModalCancel() {
        this.showEnrollmentModal = false;
        this.selectedCourseId = null;
    }

    async handleEnrollFromChild(event) {
        const { customerId, courseId } = event.detail;
        try {
            await enrollCustomerInCourse({ courseId, customerId });
            this.showToast('Success', 'Customer enrolled successfully!', 'success');
            this.showEnrollmentModal = false;
            await refreshApex(this.wiredCoursesResult);
        } catch (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}