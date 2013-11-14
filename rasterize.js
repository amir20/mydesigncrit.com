var page = require('webpage').create(),
    system = require('system'),
    address, output;

if (system.args.length != 3) {
    console.log('Usage: rasterize.js URL filename');
    phantom.exit(1);
} else {
    address = system.args[1];
    output = system.args[2];
    page.viewportSize = { width: 2 * 1024, height: 600 };
    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('Unable to load the address!');
            phantom.exit();
        } else {
            window.setTimeout(function () {
                page.render(output);
                var title = page.evaluate(function () {
                    return document.title;
                });
                console.log(JSON.stringify({title: title}));
                phantom.exit();
            }, 200);
        }
    });
}
