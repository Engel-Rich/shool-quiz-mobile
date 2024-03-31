import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// import '../utils/constants.dart';
// import 'package:nb_utils/nb_utils.dart';

class ChatSCreen extends StatefulWidget {
  const ChatSCreen({Key? key}) : super(key: key);

  @override
  State<ChatSCreen> createState() => _ChatSCreenState();
}

class _ChatSCreenState extends State<ChatSCreen> {
  TextEditingController controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: boldTextStyle()
              .copyWith(fontWeight: FontWeight.w400, fontSize: 25),
        ),
      ),
      body: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 12),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    'Comming soon...!',
                    style: boldTextStyle().copyWith(fontSize: 30),
                  ),
                ),
                // child: ListView(
                //  physics: const BouncingScrollPhysics(),
                //   children: List.generate(200, (index) =>Text(index.toString()) ).toList(),
                // ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                controller: controllerMessage,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                minLines: 1,
                style: primaryTextStyle().copyWith(fontSize: 15),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Posez une question...',
                  hintStyle: primaryTextStyle().copyWith(fontSize: 15),
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_circle_up_sharp,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
