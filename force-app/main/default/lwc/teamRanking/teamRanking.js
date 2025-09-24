import { LightningElement, track } from 'lwc';
import getTeamRanking from '@salesforce/apex/TeamRankingController.getTeamRanking';
import getTotalTeamsCount from '@salesforce/apex/TeamRankingController.getTotalTeamsCount';

const PAGE_SIZE = 10;

export default class TeamRanking extends LightningElement {
    
    @track teams = [];
    @track expandedTeamIds = new Set();
    @track searchTerm = '';
    @track currentPage = 1;
    @track totalTeams = 0;

    // ✅ Ensure only one connectedCallback exists
   connectedCallback() {
        console.log('Connected callback triggered');
        this.loadTeams();
        this.loadTotalCount();
    }

    get totalPages() {
        return Math.ceil(this.totalTeams / PAGE_SIZE);
    }

   loadTeams() {
        console.log('Calling getTeamRanking with:', this.searchTerm, this.currentPage);
        const offset = (this.currentPage - 1) * PAGE_SIZE;
        getTeamRanking({ 
            searchTerm: this.searchTerm && this.searchTerm.trim() !== '' ? this.searchTerm : null,
            offsetNum: offset, 
            limitNum: PAGE_SIZE 
        })
        .then(data => {
            console.log('Received team data:', data);
            this.teams = data.map(team => ({
                ...team,
                isExpanded: false,
                iconName: 'utility:chevronright',
                detailsKey: team.teamId + '-details'
            }));
            this.expandedTeamIds.clear();
        })
        .catch(error => {
            console.error('Error loading teams:', error);
            this.teams = [];
        });
    }


    loadTotalCount() {
        console.log('Calling getTotalTeamsCount with:', this.searchTerm);
        getTotalTeamsCount({ searchTerm: this.searchTerm })
            .then(count => {
                console.log('Total teams count:', count);
                this.totalTeams = count;
            })
            .catch(error => {
                console.error('Error loading total teams count:', error);
                this.totalTeams = 0;
            });
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        this.currentPage = 1;
        this.loadTeams();
        this.loadTotalCount();
    }

    toggleExpand(event) {
        const teamId = event.currentTarget.dataset.id;

        if (this.expandedTeamIds.has(teamId)) {
            this.expandedTeamIds.delete(teamId);
        } else {
            this.expandedTeamIds.add(teamId);
        }

        this.teams = this.teams.map(team => ({
            ...team,
            isExpanded: this.expandedTeamIds.has(team.teamId),
            iconName: this.expandedTeamIds.has(team.teamId) ? 'utility:chevrondown' : 'utility:chevronright'
        }));
    }

    goToPage(event) {
        const page = parseInt(event.target.dataset.page, 10);
        if (page >= 1 && page <= this.totalPages && page !== this.currentPage) {
            this.currentPage = page;
            this.loadTeams();
        }
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.loadTeams();
        }
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.loadTeams();
        }
    }

    get isPreviousDisabled() {
        return this.currentPage === 1;
    }

    get isNextDisabled() {
        return this.currentPage === this.totalPages;
    }

    get paginationButtons() {
        return Array.from({ length: this.totalPages }, (_, i) => ({
            page: i + 1,
            className: this.currentPage === i + 1 ? 'slds-button slds-button_brand' : 'slds-button slds-button_neutral'
        }));
    }
}
