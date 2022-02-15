import 'package:flutter/material.dart';
import 'add_contact.dart';
import 'contacts.dart';
import 'helper.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SQLite'),
      ),
      //add Future Builder to get contacts
      body: FutureBuilder<List<Contact>>(
        future: DBHelper.readContacts(), //read contacts list here
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          //if snapshot has no data yet
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Loading...'),
                ],
              ),
            );
          }
          //if snapshot return empty [], show text
          //else show contact list
          return snapshot.data!.isEmpty
              ? const Center(
                  child: Text('No Contact in List yet!'),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 0.1,
                      color: Colors.black,
                    )),
                    columns: const [
                      DataColumn(label: Text('NAME')),
                      DataColumn(
                          label: VerticalDivider(
                        thickness: 1,
                      )),
                      DataColumn(label: Text('CONTACT')),
                      DataColumn(
                          label: VerticalDivider(
                        thickness: 1,
                      )),
                      DataColumn(label: Text('EDIT')),
                      DataColumn(
                          label: VerticalDivider(
                        thickness: 1,
                      )),
                      DataColumn(label: Text('DELETE')),
                    ],
                    rows: snapshot.data!
                        .map((contacts) => DataRow(cells: [
                              DataCell(Text(contacts.name)),
                              const DataCell(VerticalDivider(
                                thickness: 1,
                              )),
                              DataCell(Text(contacts.contact)),
                              const DataCell(VerticalDivider(
                                thickness: 1,
                              )),
                              DataCell(const Icon(Icons.edit), onTap: () async {
                                final refresh = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => AddContacts(
                                              contact: contacts,
                                            )));

                                if (refresh) {
                                  setState(() {
                                    /**/
                                    //if return true, rebuild whole widget
                                  });
                                }
                              }),
                              const DataCell(VerticalDivider(
                                thickness: 1,
                              )),
                              DataCell(const Icon(Icons.delete), onTap: () {
                                DBHelper.deleteContacts(contacts.id!);
                                setState(() {});
                              }),
                            ]))
                        .toList(),
                  ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final refresh = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddContacts()));

          if (refresh) {
            setState(() {
              //if return true, rebuild whole widget
            });
          }
        },
      ),
    );
  }
}
