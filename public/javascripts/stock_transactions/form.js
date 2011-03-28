var DataFormatter = function() {
    this.format = function(jsonData) {
        return $(jsonData).map(function() {
            return {
                id:this.id,
                label : this.name
            };
        });
    }
};


$("#stock_transaction_company").autocomplete({
    source: function(request, response) {
        var url = $('#stock_transaction_company').attr('data-url');
        $.getJSON(url, {name_like: request.term, format: 'json' }, function(data) {
            response(new DataFormatter().format(data));
        });
    },
    minLength: 2,
    select: function(event, ui) {
        $('#stock_transaction_company_id').val(ui.item.id);
        return false;
    }
});
