describe("Row", function() {
    it("should set the name and initialize values", function() {
        var row = new Row("test");
        expect(row.name).toEqual("test");
        expect(row.values).toEqual([]);

    });

    it("should return true if name matches a single value", function() {
        var row = new Row("test");
        expect(row.hasName("test")).toEqual(true);
    });

    it("should return true if name matches an array of values", function() {
        var row = new Row("test");
        expect(row.hasName(["best","test"])).toEqual(true);
    });

    it("should add values", function() {
        var row = new Row("test");
        row.addValue(10.34);
        expect(row.values).toEqual([10.34]);

        row.addValue(3.59);
        expect(row.values).toEqual([10.34, 3.59]);
    })
});