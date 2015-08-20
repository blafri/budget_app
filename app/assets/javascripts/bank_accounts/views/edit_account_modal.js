BankAccount.Views.EditAccountModal = Backbone.View.extend({
  initialize: function() {
    this.model.on( 'change', this.render, this );
  },

  events: {
    'click .btn-save': 'save',
    'click .btn-cancel': 'cancel'
  },

  cancel: function() {
    $('#edit-account-modal').one('hidden.bs.modal', $.proxy(function (e) {
      this.render();
    }, this));

    $( '#edit-account-modal' ).modal('hide');
  },

  save: function() {
    $('#edit-account-modal').one('hidden.bs.modal', $.proxy(function (e) {
      var newName = this.$( 'input' ).val();
      this.model.set({name: newName});
      this.model.save({
        error: function() {
          alert('There was a problem saving your data. Please try again.');
          this.model.fetch();
        }
      });
    }, this));

    $( '#edit-account-modal' ).modal('hide');
  },

  template: JST['templates/bank_accounts/edit_account_modal'],

  render: function() {
    var attributes = this.model.toJSON();
    this.$el.html( this.template(attributes) );
  }
});
