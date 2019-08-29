/**
 * Created by sebastiankessel on 08/27/2019.
 */

import { LightningElement, track} from 'lwc';
import { publish,createMessageContext,releaseMessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import SAYWHATMC from "@salesforce/messageChannel/SayWhat__c";

export default class TestMessageLwc extends LightningElement {
    @track myMessage = '';
    @track receivedMessage = '';

    channel;

    context = createMessageContext();

    constructor() {
        super();
    }

    handleSubscribe() {
        const parentPage = this;

        this.channel = subscribe(this.context, SAYWHATMC, function (event){
            if (event != null) {
                const message = event.messageToSend;
                const source = event.sourceSystem;

                parentPage.receivedMessage = 'Message: ' + message + '. Sent From: ' + source;
            }
        });
    }

    handleUnsubscribe() {
        unsubscribe(this.channel);
    }

    handleChange(event) {
        this.myMessage = event.target.value;
    }

    handleClick() {
        const payload = {
            sourceSystem: "lwc",
            messageToSend: this.myMessage
        };

        publish(this.context, SAYWHATMC, payload);
    }

    disconnectedCallback() {
        releaseMessageContext(this.context);
    }
}