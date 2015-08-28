var BankAccount = BankAccount || {};

BankAccount.AccountEditModal = React.createClass({
  openModal: function() {
    this.refs.modal.open();
  },

  handleCancel: function() {
    React.findDOMNode(this.refs.acctNameInput).value = this.props.acctName;
    this.refs.modal.close();
  },

  handleConfirm: function() {
    var new_name = React.findDOMNode(this.refs.acctNameInput).value.trim();
    this.refs.modal.close();
    this.props.onNameChange(new_name);
  },

  render: function() {
    return (
      <Bootstrap.Modal ref="modal"
                       confirm="Update Account"
                       cancel="Cancel"
                       title="Update Account Name"
                       modalSize="modal-sm"
                       onCancel={this.handleCancel}
                       onConfirm={this.handleConfirm}>
        <div className="form-group">
          <input type="text" id="edit-account-name" className="form-control" ref="acctNameInput" defaultValue={this.props.acctName} />
        </div>
      </Bootstrap.Modal>
    );
  }
});
