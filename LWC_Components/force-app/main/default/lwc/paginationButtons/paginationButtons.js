import { LightningElement, api } from 'lwc';

export default class PaginationButtons extends LightningElement {
    @api currentPage;
    @api totalPages;

    get isFirstPage() {
        return this.currentPage<=1;
    }

    get isLastPage() {
        return this.currentPage >= this.totalPages;
    }

    handlePrevious() {
        this.dispatchEvent(new CustomEvent('previous'));
    }

    handleNext() {
        this.dispatchEvent(new CustomEvent('next'));
    }
}