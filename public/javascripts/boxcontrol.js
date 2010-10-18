Event.observe(window, "load", function() {
  var toggle_network_static_inputs = function(enable) {
    $('network_static_inputs').select("input[type=text]").each(function(input) {
      if (enable) {
        input.enable();
      } else {
        input.disable();
      }
    });
  };

  $$('input[type=radio][name="network[method]"]').each(function(radio) {
    if (radio.value == "static") {
      toggle_network_static_inputs(radio.checked);
    }
    Event.observe(radio, 'change', function() {
      toggle_network_static_inputs(radio.getValue() == "static");
    });
  });
});

/*
  When a download_pending link is detected, we're checking
  every 5 seconds the release status (by retrieving the json).
  When release is downloaded, we're reloading the page.
*/
Event.observe(window, "load", function() {
    download_pending_event = $$('.download-pending').first();
    if (download_pending_event) {
        new ReleaseDownloadObserver(download_pending_event.href, download_pending_event.getAttribute("data-release-id"));
    };
});

ReleaseDownloadObserver = Class.create({
    initialize: function(base_url, identifier) {
        this.base_url = base_url;
        this.identifier = identifier;
        this.periodical_executer();
    },
    reload_when_downloaded: function(transport) {
        var release = transport.responseText.evalJSON().release;
        console.log(release);
        if (release.status != 'download_pending') {
            this.reload_page();
        }
    },
    reload_page: function() {
        window.location = this.base_url;
    },
    check_if_release_is_downloaded: function() {
        new Ajax.Request(this.base_url + "/" + this.identifier + ".json", { 
            asynchronous: true, evalScripts: true, method: 'get', onSuccess: this.reload_when_downloaded.bind(this)
        });
    },
    update_release_description: function() {
        new Ajax.Updater({ success: 'release_' + this.identifier }, this.base_url + '/' + this.identifier + "/description", {
            method: 'get', onFailure: this.reload_page.bind(this)
        });
    },
    update_release: function() {
        this.check_if_release_is_downloaded();
        this.update_release_description();
    },
    periodical_executer: function() {
        new PeriodicalExecuter(this.update_release.bind(this), 5);
    }
});
