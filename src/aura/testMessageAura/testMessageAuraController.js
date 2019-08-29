/**
 * Created by sebastiankessel on 08/27/2019.
 */

({
    handleClick: function(component, event, helper) {
        let myMessage = component.get("v.myMessage");

        const payload = {
            sourceSystem: "Aura",
            messageToSend: myMessage
        };

        component.find("sayWhatChannel").publish(payload);
    },
    handleReceiveMessage: function (component, event, helper) {

        if (event != null) {
            const message = event.getParam('messageToSend');
            const source = event.getParam('sourceSystem');

            component.set("v.receivedMessage", 'Message: ' + message + '. Sent From: ' + source);
        }

    }
});