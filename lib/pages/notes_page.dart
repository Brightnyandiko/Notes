import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //text controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

  // on app startup, fetch existing notes
  readNotes();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   // on app startup, fetch existing notes
  //   readNotes();
  // }

  //create a note
  void createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            //create button
            MaterialButton(
              onPressed: () {
                //add to db
                context.read<NoteDatabase>().addNote(textController.text);

                //clear the controller
                textController.clear();

                //pop the dialog
                Navigator.pop(context);
              },
              child: const Text("Create"),
            )
          ]
      ),
    );
  }

  //read notes
  void readNotes() {
    // if (context.mounted) {
      context.read<NoteDatabase>().fetchNotes();
    //   context.watch<NoteDatabase>().fetchNotes();
    // }

  }

  //update a note
  void updateNote(Note note) {
    //pre-fill the current note text
    textController.text = note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Update Note"),
          content: TextField(controller: textController,),
          actions: [
            MaterialButton(
                onPressed: () {
                  // update note in db
                  context.read<NoteDatabase>().updateNote(note.id, textController.text);

                  //clear controller
                  textController.clear();

                  //pop dialog box
                  Navigator.pop(context);
                },
              child: const Text("Update"),
            )
          ],
        ),
    );
  }

  //Delete a note
  void deleteNote (int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();

    //current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(title: Text("Notes"),),
      floatingActionButton: FloatingActionButton(
          onPressed: createNote,
          child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: currentNotes.length,
          itemBuilder: (context, index) {
            //get individual note
            final note = currentNotes[index];

            //list tile UI
            return ListTile(
              title: Text(note.text),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //edit button
                  IconButton(
                      onPressed: () => updateNote(note),
                      icon: Icon(Icons.edit)
                  ),

                  //delete button
                  IconButton(
                  onPressed: () => deleteNote(note.id),
                  icon: Icon(Icons.delete)
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}

