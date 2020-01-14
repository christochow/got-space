const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const db = admin.firestore();

const readSchool = async (name) => {
    let libraries = await db.collection('records').doc(name).collection('libraries').get();
    libraries.docs.forEach(e => readLibraries(e.ref.path, e));
};

const readLibraries = async (name, snapshot) => {
    if (snapshot.data()['hasChild'] === true) {
        let floors = await db.doc(name).collection('floors').get();
        let promises = [];
        for (let i = 0; i < floors.docs.length; i++) {
            let e = floors.docs[i];
            promises.push(readFloors(e.ref.path, e));
        }
        await Promise.all(promises);
        name = name.split('/');
        name[0] = 'ratings';
        name = name.join('/');
        await db.runTransaction(t => {
            return t.get(db.doc(name).collection('floors')).then(snapshot => {
                let s = snapshot.docs.map(e => e.data()['rating']);
                let total = snapshot.docs.length === 0 ? 1 : snapshot.docs.length;
                return db.doc(name).update({
                    rating: Math.round(s.reduce((accu, cur) => accu + cur, 0)*10/total)/10
                });
            });
        });
    }
};

const readFloors = async (name, snapshot) => {
    if (snapshot.data()['hasChild'] === true) {
        let subsections = await db.doc(name).collection('subsections').get();
        let promises = [];
        for (let i = 0; i < subsections.docs.length; i++) {
            let e = subsections.docs[i];
            promises.push(runTransaction(e.ref.path));
        }
        //wait for process to finish
        await Promise.all(promises);
        name = name.split('/');
        name[0] = 'ratings';
        name = name.join('/');
        await db.runTransaction(t => {
            return t.get(db.doc(name).collection('subsections')).then(snapshot => {
                let s = snapshot.docs.map(e => e.data()['rating']);
                let total = snapshot.docs.length === 0 ? 1 : snapshot.docs.length;
                return db.doc(name).update({
                    rating: Math.round(s.reduce((accu, cur) => accu + cur, 0)*10/total)/10
                });
            });
        });
    } else {
        await runTransaction(name);
    }
};

const runTransaction = async (name) => {
    let date = Date.now() - 60 * 60 * 1000;
    await db.runTransaction(t => {
        return t.get(db.doc(name).collection('records')
            // .where('timestamp', '>=', date)
        ).then(snapshot => {
            let s = snapshot.docs.map(e => e.data()['rating']);
            let total = snapshot.docs.length === 0 ? 1 : snapshot.docs.length;
            name = name.split('/');
            name[0] = 'ratings';
            name = name.join('/');
            return db.doc(name).update({
                rating: Math.round(s.reduce((accu, cur) => accu + cur, 0)*10/total)/10
            });
        });
    });
};


exports.getSchools = functions.https.onRequest(async (request, response) => {
    const data = await db.collection('schools').get();
    let schools = data.docs.map(e => e.id);
    schools.forEach(e => readSchool(e));
    response.send(JSON.stringify(schools));
});

