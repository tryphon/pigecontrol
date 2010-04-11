// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Event.observe(window, "load", function() {
    download_pending_event = $$('.download-pending').first();
    if (download_pending_event) {
        new PendingChunkObserver(download_pending_event.href);
    };
});

/*
  When a download_pending link is detected, we're checking
  every 5 seconds the chunk status (by retrieving the json).
  When completion_rate is 1, we're reloading the page.
*/
PendingChunkObserver = Class.create({
    initialize: function(link) {
        this.link = link;
        this.periodical_executer();
    },
    reload_when_completed: function(transport) {
        var chunk = transport.responseText.evalJSON().chunk;
        if (chunk.completion_rate >= 1) {
            window.location = this.link;
        }
    },
    check_if_chunk_is_completed: function() {
        new Ajax.Request(this.link + ".json", { asynchronous: true, evalScripts: true, method: 'get', onSuccess: this.reload_when_completed.bind(this)});
    },
    periodical_executer: function() {
        new PeriodicalExecuter(this.check_if_chunk_is_completed.bind(this), 5);
    }
});