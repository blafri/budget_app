var Bootstrap = Bootstrap || {};

Bootstrap.Modal = React.createClass({
  componentDidMount: function() {
    // When the component is added, turn it into a modal
    $(React.findDOMNode(this))
      .modal({backdrop: 'static', show: false});
  },

  close: function() {
    $(React.findDOMNode(this)).modal('hide');
  },

  open: function() {
    $(React.findDOMNode(this)).modal('show');
  },

  handleCancel: function() {
    if (this.props.onCancel) {
      this.props.onCancel();
    }
  },

  handleConfirm: function() {
    if (this.props.onConfirm) {
      this.props.onConfirm();
    }
  },

  render: function() {
    var confirmButton = null;
    var cancelButton = null;
    var modalDialogSize = "modal-dialog";

    if (this.props.confirm) {
      confirmButton = (
        <button type="button" className="btn btn-primary" onClick={this.handleConfirm}>{this.props.confirm}</button>
      );
    }

    if (this.props.cancel) {
      cancelButton = (
        <button type="button" className="btn btn-default" onClick={this.handleCancel}>{this.props.cancel}</button>
      );
    }

    if (this.props.modalSize) {
      modalDialogSize = modalDialogSize + ' ' + this.props.modalSize;
    }

    return (
      <div className="modal fade">
        <div className={modalDialogSize}>
          <div className="modal-content">
            <div className="modal-header">
              <button type="button"
                      className="close"
                      aria-label="Close"
                      onClick={this.handleCancel}>
                <span aria-hidden="true">&times;</span>
              </button>
              <h4>{this.props.title}</h4>
            </div>
            <div className="modal-body">
              {this.props.children}
            </div>
            <div className="modal-footer">
              {cancelButton}
              {confirmButton}
            </div>
          </div>
        </div>
      </div>
    );
  }
});
