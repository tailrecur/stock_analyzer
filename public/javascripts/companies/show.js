var viewModel = {
    periods: ko.observableArray([]),
    rows: ko.observableArray([]),
    formulae: ko.observableArray([])
};
ko.applyBindings(viewModel);

$("#tabs").tabs({
    show: function(event, ui) {
        var url = $(ui.tab).attr('data-url');
        if ($(ui.tab).attr('href') == '#data_tab') {
            $.getJSON(url, { per_page: 5, format: 'json' }, function(data) {
                var parser = new Parser(data);
                viewModel.periods = parser.periods;
                viewModel.rows = parser.rows;
                ko.applyBindings(viewModel);
            });
        }
    }
});

$(document).ready(function() {
    var url = $('#formula_link').attr('data-url');
    $.getJSON(url, { format: 'json' }, function(data) {
        $(data).each(function() {
            viewModel.formulae.push(this);
        });
        $("table.tablesorter").tablesorter({ sortList: [[3,1]]});
    });
});