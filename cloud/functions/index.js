const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const db = admin.firestore();

const readSchool = async (name) => {
    let libraries = await db.collection('records').doc(name).collection('libraries').get();
    libraries.docs.forEach(e => readLibraries(e.ref.path));
};

const readLibraries = async (name) => {
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
                rating: Math.round(s.reduce((accu, cur) => accu + cur, 0) * 10 / total) / 10
            });
        });
    });
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
                    rating: Math.round(s.reduce((accu, cur) => accu + cur, 0) * 10 / total) / 10
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
        return t.get(db.doc(name).collection('records').where('timestamp', '>=', date)
        ).then(snapshot => {
            let s = snapshot.docs.map(e => e.data()['rating']);
            let total = snapshot.docs.length === 0 ? 1 : snapshot.docs.length;
            name = name.split('/');
            name[0] = 'ratings';
            name = name.join('/');
            return db.doc(name).update({
                rating: Math.round(s.reduce((accu, cur) => accu + cur, 0) * 10 / total) / 10
            });
        });
    });
};

const delSchoolRecords = async (name) => {
    let libraries = await db.collection('records').doc(name).collection('libraries').get();
    libraries.docs.forEach(e => delLibraryRecords(e.ref.path));
};

const delLibraryRecords = async (name) => {
    let floors = await db.doc(name).collection('floors').get();
    let promises = [];
    for (let i = 0; i < floors.docs.length; i++) {
        let e = floors.docs[i];
        promises.push(delFloorRecords(e.ref.path, e));
    }
    await Promise.all(promises);
};

const delFloorRecords = async (name, snapshot) => {
    if (snapshot.data()['hasChild'] === true) {
        let subsections = await db.doc(name).collection('subsections').get();
        let promises = [];
        for (let i = 0; i < subsections.docs.length; i++) {
            let e = subsections.docs[i];
            promises.push(runDelTransaction(e.ref.path));
        }
        //wait for process to finish
        await Promise.all(promises);
    } else {
        await runDelTransaction(name);
    }
};

const runDelTransaction = async (name) => {
    let date = Date.now() - 60 * 60 * 1000;
    let snapshot = await db.doc(name).collection('records').where('timestamp', '<', date).get();
    if(snapshot.size===0){
     return;
    }
    let batch = db.batch();
    snapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
    });
    await batch.commit();
    await process.nextTick(() => {
        runDelTransaction(name);
    });
};

startRead = async () => {
    const data = await db.collection('schools').get();
    let promises = [];
    for(let i=0;i<data.docs.length;i++){
        promises.push(readSchool(data.docs[i].id))
    }
    await Promise.all(promises);
};

startDelete = async () => {
    const data = await db.collection('schools').get();
    let schools = data.docs.map(e => e.id);
    let promises = [];
    for(let i=0;i<data.docs.length;i++){
        promises.push(delSchoolRecords(schools[i].id))
    }
    await Promise.all(promises);
};

exports.getSchools = functions.https.onRequest(async (request, response) => {
    await startRead();
    response.send('read done');
});

exports.delSchools = functions.https.onRequest(async (request, response) => {
    await startDelete();
    response.send('delete done')
});

exports.updateRatings = functions.pubsub
    .schedule('30 * * * *')
    .timeZone('America/New_York')
    .onRun(startRead);

exports.delRecords = functions.pubsub
    .schedule('0 0 * * *')
    .timeZone('America/New_York')
    .onRun(startDelete);

