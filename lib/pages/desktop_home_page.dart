import 'package:flutter/material.dart';
import 'package:geek_chat/components/chat/chat_list_menu_item.dart';
import 'package:geek_chat/components/chat/menu_button.dart';
import 'package:geek_chat/components/desktop_main_right_component.dart';
import 'package:geek_chat/controller/chat_list_controller.dart';
import 'package:geek_chat/controller/chat_message_controller.dart';
import 'package:geek_chat/controller/settings.dart';
import 'package:geek_chat/models/session.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DesktopHomePage extends StatelessWidget {
  DesktopHomePage({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (settingsController.needSettings) {
        Get.toNamed("/dsettings");
      }
    });
  }

  ChatListController chatListController = Get.find();
  SettingsController settingsController = Get.find<SettingsController>();
  ChatMessageController chatMessageController =
      Get.find<ChatMessageController>();

  Widget getPriceMenu() {
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
        child: Row(
          children: [
            Container(
              // color: Colors.white10,
              padding: EdgeInsets.only(top: 10),
              child: SizedBox(
                width: 240,
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                      child:  Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(shape: MaterialStateProperty.all(CircleBorder())),
                            onPressed: () {
                              Get.toNamed('/editchat', parameters: {'opt': 'new', 'sid': ''});
                            },
                            child: Icon(
                              Icons.menu,
                              size: 25,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.only(right: 20),
                                child: TextField(
                                    decoration: InputDecoration(
                                      isCollapsed: false,
                                      contentPadding: EdgeInsets.only(left: 15),
                                      hintText: "Search",
                                      hintStyle: TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50),borderSide: BorderSide.none),
                                      enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(50),borderSide: BorderSide.none),
                                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50),borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50),borderSide: BorderSide.none),
                                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50),borderSide: BorderSide.none),
                                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50),borderSide: BorderSide.none),
                                    )
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child:
                      GetBuilder<ChatListController>(builder: (controller) {
                        return ListView.builder(
                            itemCount: controller.sessions.length,
                            controller: ScrollController(),
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ChatListMenuItemComponent(
                                  session: controller.sessions.elementAt(index),
                                  onTap: (String sid) {
                                    controller.switchSession(sid);
                                    controller.update();
                                  },
                                  currentSession: controller.currentSession,
                                  onDelete: (SessionModel session) {
                                    chatMessageController
                                        .cleanSessionMessages(session.sid);
                                    controller.remove(session);
                                    controller.reloadSessions();
                                    controller.update();
                                  });
                            });
                      }),
                    ),

                    SizedBox(
                      height: 0,
                      width: double.infinity,
                      child: Column(children: [
                        LeftMenuButtonComponent(
                          title: "Prompts".tr,
                          onPressed: () {
                            Get.toNamed("/prompts");
                          },
                          icon: Icons.smart_toy_outlined,
                        ),
                        LeftMenuButtonComponent(
                          title: "Settings".tr,
                          onPressed: () {
                            Get.toNamed("/dsettings");
                          },
                          icon: Icons.settings,
                        ),
                        getPriceMenu(),
                        LeftMenuButtonComponent(
                          title:
                          "${'About'.tr}(v${settingsController.packageInfo.version})",
                          onPressed: () {
                            Get.toNamed("/about");
                            // Get.snackbar(
                            //   'Sorry!'.tr,
                            //   'This feature will coming soon!'.tr,
                            //   duration: const Duration(seconds: 2),
                            //   snackPosition: SnackPosition.TOP,
                            // );
                          },
                          icon: Icons.info_outline,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 1,
              child: Container(
                color: Colors.grey.shade100,
              ),
            ),
            Expanded(
              child: Container(
                child: GetBuilder<ChatListController>(builder: (controller) {
                  return chatListController.currentSessionId.isEmpty
                      ? const Text("")
                      : DeskTopMainRightComponent(
                      sid: chatListController.currentSession.sid);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
