({
    processResults: function (results, returnFields, searchText) {
        window.console.log(results);
        window.console.log(returnFields);
        let regEx = null;

        if (searchText != null && searchText.length > 0) {
            regEx = new RegExp(searchText, 'gi');
        }

        for (let i = 0; i < results.length; i++) {

            results[i]['Field0'] = results[i][returnFields[0]].replace(regEx, '<mark>$&</mark>');

            for (let j = 1; j < returnFields.length; j++) {
                if (returnFields[j].indexOf('.') > 0) {
                    let fields = returnFields[j].split('.');
                    let fieldValue = results[i][fields[0]];
                    if (fieldValue) {
                        results[i]['Field1'] = (results[i]['Field1'] || '') + ' • ' + fieldValue[fields[1]];
                    }
                } else {
                    let fieldValue = results[i][returnFields[j]];
                    if (fieldValue) {
                        results[i]['Field1'] = (results[i]['Field1'] || '') + ' • ' + fieldValue;
                    }
                }
            }

            if (results[i]['Field1']) {
                results[i]['Field1'] = results[i]['Field1'].substring(3).replace(regEx, '<mark>$&</mark>');
            }
        }

        return results;
    }
})