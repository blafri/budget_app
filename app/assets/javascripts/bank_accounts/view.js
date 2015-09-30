var BankAccount = BankAccount || {};

BankAccount.View = Backbone.View.extend({
    initialize: function(){
        this.model.on('change', this.render, this);
    },

    showNameEdit: function(event) {
        event.preventDefault();

        var $displayAccount = this.$el.find( '#display-account-name' );
        var $editAccount = this.$el.find( '#edit-account-name' );

        $displayAccount.hide();
        $editAccount.show();
        $editAccount.find( 'input' ).focus();
    },

    updateAccountName: function(event) {
        event.preventDefault();
        var value = this.$el.find( '#edit-account-name input' ).val();
        this.model.updateAccountName(value);
    },

    events: {
        'click .glyphicon-edit': 'showNameEdit',
        'click #edit-account-name button': 'updateAccountName'
    },

    template: JST['templates/bank_accounts/account_details'],

    render: function() {
        var attributes = this.model.toJSON();
        this.$el.html( this.template(attributes) );
    }
});
