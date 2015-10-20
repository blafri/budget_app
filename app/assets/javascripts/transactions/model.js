var Transaction = Transaction || {};

Transaction.Model = Backbone.Model.extend({
    urlRoot: '/api/v1/acct_trans'
});
