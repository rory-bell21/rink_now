const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const firestore = admin.firestore();
const settings = { timestampInSnapshots: true };
firestore.settings(settings);

//const stripe = require('stripe')(functions.config().stripe.token);

var stripe = require("stripe")("sk_test_qB1nqkICI1qTMBgkVirAEnpu00eYrxaqQR");

exports.addStripeSource = functions.firestore.document('cards/{userid}/tokens/{tokenid}').onCreate(async (tokenSnap, context) => {
        var customer;
        var data = tokenSnap.data();
        if (data === null) {
                return null;
        }
        const token = data.tokenid;


        const snapshot = await firestore.collection('cards').doc(context.params.userid).get();//this will be the userID from cards doc in firestore
        console.log(".5");
        const customerId = snapshot.data().custId;
        console.log(".66");
        const customerEmail = snapshot.data().email;
        console.log(".77");
        console.log(customerId);
        //if (customerId === 'new') {
        console.log("1");
        customer = await stripe.customers.create({
                email: customerEmail,
                source: token
        });
        console.log("2");
        firestore.collection('cards').doc(context.params.userid).update({
                custId: customer.id //this is updating customerId in firestore
        });
        console.log("3");
        //}
        // else {
        //        customer = await stripe.customers.retrieve(customerId);
        // }
        console.log("4");
        console.log(customer.sources)
        const customerSource = customer.sources.data[0];
        console.log("5");
        console.log(customerSource);
        return firestore.collection('cards').doc(context.params.userid).collection('sources').doc(customerSource.card.fingerprint).set(customerSource, { merge: true });
})

exports.createCharge = functions.firestore.document('cards/{userid}/charges/{chargeid}').onCreate(async (chargeSnapId, context) => {
        try {

                const chargeSnap = await firestore.collection('cards').doc(context.params.userid).get();
                //const chargeSnapInfo = await firestore.collection('cards').doc(context.params.userid.charges).get();

                //string userIdent = context.params.userid;
                //const chargeSnapId = await firestore.collection('charges').doc(context.params.chargeId).get(); //lowercase next
                // console.log("chargesnapID^");
                //console.log(chargeSnapId);
                //console.log("chargesnapinfo^");
                //console.log(chargeSnapInfo);
                console.log("chargeSnap^");
                console.log(chargeSnap);
                const customer = chargeSnap.data().custId;
                const amount = chargeSnapId.data().amount;
                const currency = "cad";
                const description = chargeSnapId.data().description;
                console.group("amount^");
                console.log(amount);
                const charge = { amount, currency, customer, description };
                const idempotentKey = context.params.chargeId; //might need to change to chargeid
                const response = await stripe.charges.create(charge, { idempotency_key: idempotentKey });
                console.log("hello");
                return chargeSnapId.ref.set(response, { merge: true });

        }
        catch (error) {
                console.log(context.params.userid);
                await chargeSnap.ref.set({ error: error.message }, { merge: true });
        }

});






