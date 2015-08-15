// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// This function is to call the modal on the dashboards page
$(function() {

    // declare variables
    var $modal = $( '#action-modal' );

    // Setup modal
    $modal.modal({
        backdrop: 'static',
        show: false
    });

    // set modal contents when modal is shown
    $modal.on( 'show.bs.modal', function (event) {
        $( '#action-modal .modal-title' ).append( '<h4>Loading</h4>' )
        var $button = $(event.relatedTarget)

        $.getScript($button.data('content-path'), function( data, textStatus, jqxhr ) {

            if ( jqxhr.status == 200 ) {
                $( '.modal-ajax-indicator' ).hide();
            }

        });
    });

    // reset modal when modal is hidden
    $modal.on( 'hidden.bs.modal', function() {
        $( '#action-modal .modal-title' ).empty();
        $( '#action-modal .modal-body .content' ).empty();
        $( '#action-modal .btn-submit' ).remove();
        $( '#action-modal .btn-delete' ).remove();
        $( '.modal-ajax-indicator' ).show();
    });
});// End of function
