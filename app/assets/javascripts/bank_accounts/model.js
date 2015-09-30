var BankAccount = BankAccount || {};

BankAccount.Model = Backbone.Model.extend({
    urlRoot: '/api/v1/bank_accounts',

    updateAccountName: function(newName) {
        if (newName === this.get('name')) {
            // If the elements are the same trigger change event anyway to
            // re-render the view this is needed to hide the input box and clear
            // out any crap that was in it.
            this.trigger('change')
        } else {
            this.set({'name': newName});
            this.save();
        }
    }
});
