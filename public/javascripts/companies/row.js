var Row = function(name) {
    this.name = name;
    this.values = [];

    this.addValue = function(value) {
        this.values.push(value);
    };

    this.hasName = function(names) {
        if (!(names instanceof Array))
            names = [names];
        return $(names).any(function() {
            return name == this;
        })
    }
};
