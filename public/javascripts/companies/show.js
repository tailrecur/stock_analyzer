$("#tabs").tabs({
    show: function(event, ui) {
        var url = $(ui.tab).attr('data-url');
        if(url) {
            $.getJSON(url, { per_page: 5, format: 'json' }, function(data) {
                ko.applyBindings(new Parser(data));
            });
        }
    }
});