// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// This function is to call the modal on the dashboards page
$(function() {

    if ( '.dashboards-index' ) {

        // declare variables
        var $modal = $( '#dashboard-modal' );

        // Setup modal
        $modal.modal({
            backdrop: 'static',
            show: false
        });

        // set modal contents when modal is shown
        $modal.on( 'show.bs.modal', function (event) {
            var $button = $(event.relatedTarget)
            $.getScript($button.data('content-path'));
        });

        // reset modal when modal is hidden
        $modal.on( 'hidden.bs.modal', function() {
            $( '#dashboard-modal .modal-title' ).empty();
            $( '#dashboard-modal .modal-body' ).empty();
            $( '#dashboard-modal .btn-submit' ).remove();
        });

    }// End of if statement

});// End of function
