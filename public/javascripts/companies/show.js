$(document).ready(function() {
  var viewModel = {
    retrieve: function(url) {
      $.getJSON(url, { per_page: 5, format: 'json' }, function(data) {
        ko.applyBindings(new Parser(data));
      });

    },
    periods: [],
    rows: []
  };

  ko.applyBindings(viewModel);
});

//$("#tabs").tabs({
//    select: function(event, ui) {
//        url = $.data(ui.tab, 'load.tabs');
//        $(ui.panel).html("testttttttassssssssssinnnnnnnn111111111111nnnnnn");
//        alert(1);
//        $.ajax({
//            url: url,
//            success: function(data) {
//                alert($(ui.panel).html());
////                parser = new Parser(data);
//                alert(ui.panel);
//                $(ui.panel).html("testttttttassssssssssinnnnnnnnnnnnnn");
//            }
//        });
//        return true;
//    }
//});