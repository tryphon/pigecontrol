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
    download_pending_event = $$('.download-pending.release').first();
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
        var release = transport.responseText.evalJSON();
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

/* */

Event.observe(window, "load", function() {
  if ($$('body.streams.edit')) {
  var toggle_stream_optional_inputs = function(select) {
    var selected_option = $A(select.options).find(function(o) { return o.selected; });
    var disabled_attributes = (selected_option.getAttribute("data-disabled") || "").split(" ");

    ["mount_point", "server", "port", "password"].each(function(attribute) {
      var enable = disabled_attributes.indexOf(attribute) == -1;
      $$('input[name="stream[' + attribute + ']"]').each(function(input) {
        if (enable) {
          input.up().show();
        } else {
          input.up().hide();
        };
      });                                                                 
    });

  };

  $$('select[name="stream[server_type]"]').each(function(select) {
    toggle_stream_optional_inputs(select);

    Event.observe(select, 'change', function() {
      toggle_stream_optional_inputs(select);
    });
  });


  // Disable Stream#mount_point in /streams/_form for shoutcast servers
  var toggle_stream_bitrate_quality = function(attribute, enable) {
    $$('[name="stream[' + attribute + ']"]').each(function(input) {
      if (enable) {
        input.up().show();
      } else {
        input.up().hide();
      };
    });
  };

  var toggle_stream_mode = function(attribute, enable) {
    $$('[id="stream_mode_' + attribute + '"]').each(function(input) {
      if (enable) {
        input.up().show();
      } else {
        input.up().hide();
      };
    });
  };

  $$('input[name="stream[mode]"]').each(function(radio) {
    var allows_cbr = radio.getAttribute("data-allows-cbr") == "true";
    var allows_vbr = radio.getAttribute("data-allows-vbr") == "true";

    if (radio.checked) {
      toggle_stream_bitrate_quality("bitrate", allows_cbr);
      toggle_stream_bitrate_quality("quality", allows_vbr);
    }
                                        
    Event.observe(radio, 'change', function() {
      toggle_stream_bitrate_quality("bitrate", allows_cbr);
      toggle_stream_bitrate_quality("quality", allows_vbr);
    });
  });

  $$('input[name="stream[format]"]').each(function(radio) {
    var allows_cbr = radio.getAttribute("data-allows-cbr") == "true";
    var allows_vbr = radio.getAttribute("data-allows-vbr") == "true";

    if (radio.checked) {
      toggle_stream_mode("cbr", allows_cbr);
      toggle_stream_mode("vbr", allows_vbr);
    }
                                        
    Event.observe(radio, 'change', function(e) {
      toggle_stream_mode("cbr", allows_cbr);
      toggle_stream_mode("vbr", allows_vbr);
      replace_bitrate_select(e.element().value);
    });
  });
  }
});
