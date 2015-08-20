BankAccount.Views.BankAccountDescription = Backbone.View.extend({
  initialize: function() {
    this.model.on( 'change', this.render, this );
  },

  template: JST['templates/bank_accounts/bank_account_details'],

  render: function() {
    var attributes = this.model.toJSON();
    this.$el.html( this.template(attributes) );
  }
});
