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


$("#company").autocomplete({
    source: function(request, response) {
        var url = $('#company').attr('data-url');
        $.getJSON(url, {name_like: request.term, format: 'json' }, function(data) {
            response(new DataFormatter().format(data));
        });
    },
    minLength: 2,
    select: function(event, ui) {
        $('#company_id').val(ui.item.id);
        return false;
    }
});

$("#transaction_date").datepicker({ dateFormat: "dd M, yy", changeMonth: true, changeYear: true });