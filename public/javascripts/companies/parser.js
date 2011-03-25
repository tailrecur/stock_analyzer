function Parser(jsonData) {
    this.initialize(jsonData);
}

Parser.prototype = {
    initialize: function(jsonData) {
        this.rows = this.parseData(jsonData).sort(this.sortRow);
        this.periods = this.parsePeriods();
        this.cleanData();
        this.removeEmptyData();
    },

    parsePeriods: function() {
        var periodRow = this.rows.select(function() {
            return this.hasName("period_ended")
        })[0];
        return $(periodRow.values).collect(function() {
            return $.format.date(this + " 00:00:00", "MMM yyyy");
        })
    },

    cleanData: function() {
        this.rows = this.rows.reject(function() {
            return this.hasName(["created_at","updated_at","company_id","period_ended"]);
        });
    },

    removeEmptyData: function() {
        this.rows = $(this.rows).select(function() {
            return !$(this.values).all(function() {
              return this == 0
            });
        });
    },

    sortRow: function(a, b) {
        return a.name > b.name ? 1 : -1;
    },

    parseData: function(jsonData) {
        var parsedData = {};
        $.each(jsonData, function(index, periodicalData) {
            $.each(periodicalData, function(name, value) {
                var row = parsedData[name];
                if (row == null) {
                    row = new Row(name);
                    parsedData[name] = row;
                }
                row.addValue(value ? value : 0);
            });
        });
        var rows = [];
        for (var row in parsedData) {
            rows.push(parsedData[row]);
        }
        return $(rows);
    }
};
