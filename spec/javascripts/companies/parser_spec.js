describe("Parser", function() {
    var jsonData = $.parseJSON('[\
        {"book_value":0.0,"company_id":509,"created_at":"2011-02-19T08:00:06Z","updated_at":"2011-02-19T08:00:06Z","depreciation":0.06,"depreciation_for_previous_years":0.0,\
            "depreciation_on_revaluated_assets":null,"dividend":0.0,"dividend_percentage":0.0, "period_ended":"2009-12-01"},\
        {"book_value":0.0,"company_id":509,"created_at":"2011-02-19T08:00:06Z","updated_at":"2011-02-19T08:00:06Z","depreciation":0.11,"depreciation_for_previous_years":0.0,\
            "depreciation_on_revaluated_assets":3.0,"dividend":0.0,"dividend_percentage":0.0, "period_ended":"2008-12-01"}\
    ]');

    it("should parse JSON data", function() {
        var parser = new Parser(jsonData);
        expect(parser.rows.length).toBeGreaterThan(0);
        var row = $(parser.rows).select(function() {
            return this.hasName("depreciation_on_revaluated_assets")
        })[0];
        expect(row.values[0]).toEqual(0);
    });

    it("should show periods in readable format", function() {
        var parser = new Parser(jsonData);
        expect(parser.periods).toEqual(["Dec 2009", "Dec 2008"]);
    });

    it("should remove unnecessary rows", function() {
        var parser = new Parser(jsonData);
        var rowNames = parser.rows.map(function(row) {
            return row.name;
        });
        expect(rowNames).not.toContain("created_at");
        expect(rowNames).not.toContain("updated_at");
        expect(rowNames).not.toContain("company_id");
        expect(rowNames).not.toContain("period_ended");
    });

    it("should remove empty rows", function() {
        var parser = new Parser(jsonData);
        var rowNames = parser.rows.map(function(row) {
            return row.name;
        });
        expect(rowNames).not.toContain("dividend_percentage");
        expect(rowNames).not.toContain("dividend");
    });
});