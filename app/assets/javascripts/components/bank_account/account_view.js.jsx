var BankAccount = BankAccount || {};

BankAccount.AccoutView = React.createClass({
  getInitialState: function() {
    return {account: {name: this.props.bank_account.name,
                      balance: this.props.bank_account.formated_balance}};
  },

  openModal: function(e) {
    // Get the data-modal attribute set on the button that was clicked
    var modalTarget = $( e.target ).data('modal');

    // Open the correct modal depending on the data-modal attribute set on the
    // button
    switch (modalTarget) {
    case 'accountModal':
      this.refs.accountModal.openModal();
      break;
    }
  },

  handleAcctNameChange: function(new_name) {
    // change the state to include the new bank account name.
    var new_state = this.state
    new_state.account.name = new_name
    this.setState(new_state);

    // Update the data on the server.
    BankAccount.Utils.saveData(this.props.bank_account.id,
                               {bank_account: {name: new_name}});
  },

  render: function() {
    return (
      <div className="account-view">
        <div className="row">
          <div className="col-sm-12">
            <BankAccount.AccountDetails name={this.state.account.name}
                                        balance={this.state.account.balance} />
            <button type="button"
                    className="btn btn-primary acct-action"
                    data-modal="accountModal"
                    onClick={this.openModal}>
              Edit Account
            </button>
            <a href={'/bank_accounts/' + (this.props.bank_account.id)}
               className="btn btn-danger acct-action"
               data-method="delete"
               data-confirm="Are you sure you want to delete this account?">
              Delete Account
            </a>
          </div>
        </div>
        <BankAccount.AccountEditModal ref="accountModal"
                                      acctName={this.state.account.name}
                                      onNameChange={this.handleAcctNameChange}/>
      </div>
    );
  }
});
