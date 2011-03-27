$("#stock_transaction_company").autocomplete({
    source: function(request, response) {
        var url = $('#stock_transaction_company').attr('data-url');
        $.getJSON(url, {name_like: request.term, format: 'json' }, function(data) {
            var names = $(data).map(function() {
                return this.name;
            });
            response(names);
        });
    },
    minLength: 2
});

function formatData(data) {

}