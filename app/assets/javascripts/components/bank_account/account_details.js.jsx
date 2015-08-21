var BankAccount = BankAccount || {};

BankAccount.AccountDetails = React.createClass({
  render: function() {
    return(
      <div className="acct-desc">
        <p><span className="acct-desc__title">Account Name:</span> {this.props.name}</p>
        <p><span className="acct-desc__title">Account Balance:</span> {this.props.balance}</p>
      </div>
    );
  }
});
