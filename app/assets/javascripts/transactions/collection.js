var Transaction = Transaction || {};

Transaction.Collection = Backbone.Collection.extend({
    model: Transaction.Model,

    url: '/api/v1/acct_trans'
});
