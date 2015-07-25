// Close the flash messages after 3 seconds
$(function() {

    //flash notice
    if ( $( '#flash-notice' ).length ) {
      window.setTimeout(function() {
          $( '#flash-notice' ).alert('close');
      }, 3000);
    }

    //flash alert
    if ( $( '#flash-alert' ).length ) {
      window.setTimeout(function() {
          $( '#flash-alert' ).alert('close');
      }, 3000);
    }

    if ( $( '#flash-error' ).length ) {
      window.setTimeout(function() {
          $( '#flash-error' ).alert('close');
      }, 3000);
    }

});
