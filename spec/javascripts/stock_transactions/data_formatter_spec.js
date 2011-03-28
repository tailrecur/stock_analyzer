describe("DataFormatter", function() {
    var jsonData = $.parseJSON('[\
            {"active":true,"balance_sheets_count":5,"bse_code":"532174","cash_flows_count":5,"created_at":"2011-02-12T10:18:02Z","day_high":1097.0,"day_low":1059.15,\
                "id":132,"isin":"INE090A01013","mc_code":"ICI02","name":"ICICI Bank","nse_code":"ICICIBANK","price":1091.1,"profit_and_losses_count":5,\
                "quarterly_results_count":5,"score":-1,"sector_id":9,"updated_at":"2011-03-27T07:52:16Z","volume":3981956.0,"year_high":1279.0,"year_low":712.0},\
            {"active":true,"balance_sheets_count":0,"bse_code":"533244","cash_flows_count":0,"created_at":"2011-02-12T10:38:15Z","day_high":2148.2,"day_low":2080.0,\
                "id":1377,"isin":"INF109K01FV4","mc_code":"ICI10","name":"ICICI Prudential Gold Exchange Traded Fund","nse_code":"IPGETF","price":2084.7,\
                "profit_and_losses_count":0,"quarterly_results_count":0,"score":0,"sector_id":50,"updated_at":"2011-03-27T07:52:17Z","volume":86.0,"year_high":2146.7,"year_low":1860.1}]'
            );

    it("should format data to return id and name", function() {
        var formatted_data = new DataFormatter().format(jsonData);
        expect(formatted_data.size()).toEqual(2);
        first_row = formatted_data[0];
        expect(first_row.id).toEqual(132);
        expect(first_row.label).toEqual("ICICI Bank");
    });

});