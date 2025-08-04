import { LightningElement, wire, track } from 'lwc';
import getActiveCourses from '@salesforce/apex/TrainingController.getActiveCourses';

export default class CourseCatalog extends LightningElement {
    @track courses = [];
    @track filteredCourses = [];
    @track searchTerm = '';
    @track selectedCategory = '';

    @track categoryOptions = [
        { label: 'All Categories', value: '' },
        { label: 'Technical', value: 'Technical' },
        { label: 'Leadership', value: 'Leadership' },
        { label: 'Compliance', value: 'Compliance' },
        { label: 'Safety', value: 'Safety' }
    ];

    // Wire Apex data
    @wire(getActiveCourses)
    wiredCourses({ data, error }) {
        if (data) {
            this.courses = data;
            this.filteredCourses = data;
            console.log('Courses fetched:', JSON.stringify(this.courses, null, 2));
        } else if (error) {
            console.error('Error fetching courses:', error);
        }
    }

    // 🔍 Handle Search Input
    handleSearchChange(event) {
        this.searchTerm = event.target.value.toLowerCase();
        this.filterCourses();
    }

    // 📂 Handle Category Dropdown
    handleCategoryChange(event) {
        this.selectedCategory = event.detail.value;
        this.filterCourses();
    }

    // 🔁 Filter Courses
    filterCourses() {
        this.filteredCourses = this.courses.filter(course => {
            const matchesSearch = !this.searchTerm ||
                course.Name.toLowerCase().includes(this.searchTerm) ||
                (course.Description__c && course.Description__c.toLowerCase().includes(this.searchTerm));

            const matchesCategory = !this.selectedCategory ||
                course.Category__c === this.selectedCategory;

            return matchesSearch && matchesCategory;
        });
    }
}
