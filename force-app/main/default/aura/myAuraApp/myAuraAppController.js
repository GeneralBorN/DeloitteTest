({
    fetchRandomAccount: function(component, event) {
        var action = component.get("c.getRandomAccount"); // Call the new method
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var account = response.getReturnValue();
                component.set("v.account", account);
                console.log("Fetched random account", account);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error("Error fetching account: ", errors);
            }
        });
        $A.enqueueAction(action);
    },

    showMoreInfo: function(component, event) {
        component.set("v.showText", true);
    }
})
