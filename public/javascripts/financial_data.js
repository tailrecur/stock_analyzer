function Parser(jsonData) {
    this.initialize(jsonData);
}

Parser.prototype = {
    initialize: function(jsonData) {
        this.rows = this.parseData(jsonData);
        this.periods = this.parsePeriods();
        this.cleanData();
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

    parseData: function(jsonData) {
        var parsedData = {};
        $.each($.parseJSON(jsonData), function(index, periodicalData) {
            $.each(periodicalData, function(name, value) {
                var row = parsedData[name];
                if (row == null) {
                    row = new Row(name);
                    parsedData[name] = row;
                }
                row.addValue(value);
            });
        });
        var rows = [];
        for (var row in parsedData) {
            rows.push(parsedData[row]);
        }
        return $(rows);
    }
};

var Row = function(name) {
    this.name = name;
    this.values = [];

    this.addValue = function(value) {
        this.values.push(value);
    };

    this.hasName = function(names) {
        $(names).any(function() {
            return this.name == this;
        })
    }
};
