// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tim_ui_kit/base_widgets/tim_ui_kit_state.dart';
import 'package:tim_ui_kit/business_logic/view_models/tui_group_profile_view_model.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:tim_ui_kit/ui/utils/color.dart';
import 'package:tim_ui_kit/ui/views/TIMUIKitGroupProfile/widgets/tim_ui_group_member_search.dart';
import 'package:tim_ui_kit/ui/widgets/group_member_list.dart';

import 'package:tim_ui_kit/base_widgets/tim_ui_kit_base.dart';

class GroupProfileMemberListPage extends StatefulWidget {
  List<V2TimGroupMemberFullInfo?> memberList;
  TUIGroupProfileViewModel model;
  GroupProfileMemberListPage({
    Key? key,
    required this.memberList,
    required this.model,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => GroupProfileMemberListPageState();
}

class GroupProfileMemberListPageState
    extends TIMUIKitState<GroupProfileMemberListPage> {
  List<V2TimGroupMemberFullInfo?>? searchMemberList;
  String? searchText;

  _kickedOffMember(String userID) async {
    widget.model.kickOffMember([userID]);
  }

  bool isSearchTextExist(String? searchText) {
    return searchText != null && searchText != "";
  }

  handleSearchGroupMembers(String searchText, context) async {
    searchText = searchText;
    List<V2TimGroupMemberFullInfo?> currentGroupMember =
        Provider.of<TUIGroupProfileViewModel>(context, listen: false)
                .groupMemberList ??
            [];
    final res =
        await widget.model.searchGroupMember(V2TimGroupMemberSearchParam(
      keywordList: [searchText],
      groupIDList: [widget.model.groupInfo!.groupID],
    ));

    if (res.code == 0) {
      List<V2TimGroupMemberFullInfo?> list = [];
      final searchResult = res.data!.groupMemberSearchResultItems!;
      searchResult.forEach((key, value) {
        if (value is List) {
          for (V2TimGroupMemberFullInfo item in value) {
            list.add(item);
          }
        }
      });

      currentGroupMember = list;
    } else {
      currentGroupMember = [];
    }
    setState(() {
      searchMemberList =
          isSearchTextExist(searchText) ? currentGroupMember : null;
    });
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    String option1 = widget.model.groupInfo?.memberCount.toString() ??
        widget.memberList.length.toString();
    return Scaffold(
        appBar: AppBar(
            title: Text(
              TIM_t_para("群成员({{option1}}人)", "群成员($option1人)")(
                  option1: option1),
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            shadowColor: theme.weakBackgroundColor,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
                  theme.primaryColor ?? CommonColor.primaryColor
                ]),
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            )),
        body: ChangeNotifierProvider.value(
            value: widget.model,
            child: Consumer<TUIGroupProfileViewModel>(
                builder: ((context, value, child) {
              return GroupProfileMemberList(
                customTopArea: GroupMemberSearchTextField(
                  onTextChange: (text) =>
                      handleSearchGroupMembers(text, context),
                ),
                memberList: searchMemberList ?? value.groupMemberList ?? [],
                removeMember: _kickedOffMember,
                touchBottomCallBack: () {
                  widget.model
                      .loadMoreData(groupID: widget.model.groupInfo!.groupID);
                },
              );
            }))));
  }
}

class DeleteGroupMemberPage extends StatefulWidget {
  final TUIGroupProfileViewModel model;

  const DeleteGroupMemberPage({Key? key, required this.model})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeleteGroupMemberPageState();
}

class _DeleteGroupMemberPageState extends TIMUIKitState<DeleteGroupMemberPage> {
  List<V2TimGroupMemberFullInfo> selectedGroupMember = [];
  List<V2TimGroupMemberFullInfo?>? searchMemberList;

  bool isSearchTextExist(String? searchText) {
    return searchText != null && searchText != "";
  }

  handleSearchGroupMembers(String searchText, context) async {
    searchText = searchText;
    List<V2TimGroupMemberFullInfo?> currentGroupMember =
        Provider.of<TUIGroupProfileViewModel>(context, listen: false)
                .groupMemberList ??
            [];
    final res =
        await widget.model.searchGroupMember(V2TimGroupMemberSearchParam(
      keywordList: [searchText],
      groupIDList: [widget.model.groupInfo!.groupID],
    ));

    if (res.code == 0) {
      List<V2TimGroupMemberFullInfo?> list = [];
      final searchResult = res.data!.groupMemberSearchResultItems!;
      searchResult.forEach((key, value) {
        if (value is List) {
          for (V2TimGroupMemberFullInfo item in value) {
            list.add(item);
          }
        }
      });

      currentGroupMember = list;
    } else {
      currentGroupMember = [];
    }
    setState(() {
      searchMemberList =
          isSearchTextExist(searchText) ? currentGroupMember : null;
    });
  }

  handleRole(groupMemberList) {
    return groupMemberList
            ?.where((value) =>
                value?.role ==
                GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER)
            .toList() ??
        [];
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return Scaffold(
        appBar: AppBar(
            title: Text(
              TIM_t("删除群成员"),
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (selectedGroupMember.isNotEmpty) {
                    final userIDs =
                        selectedGroupMember.map((e) => e.userID).toList();
                    widget.model.kickOffMember(userIDs);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  TIM_t("确定"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
            shadowColor: theme.weakBackgroundColor,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
                  theme.primaryColor ?? CommonColor.primaryColor
                ]),
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            )),
        body: ChangeNotifierProvider.value(
            value: widget.model,
            child: Consumer<TUIGroupProfileViewModel>(
                builder: ((context, value, child) {
              return GroupProfileMemberList(
                memberList:
                    handleRole(searchMemberList ?? value.groupMemberList),
                canSelectMember: true,
                canSlideDelete: false,
                onSelectedMemberChange: (selectedMember) {
                  selectedGroupMember = selectedMember;
                },
                touchBottomCallBack: () {
                  widget.model
                      .loadMoreData(groupID: widget.model.groupInfo!.groupID);
                },
              );
            }))));
  }
}

class AddGroupMemberPage extends StatefulWidget {
  final TUIGroupProfileViewModel model;

  const AddGroupMemberPage({Key? key, required this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddGroupMemberPageState();
}

class _AddGroupMemberPageState extends TIMUIKitState<AddGroupMemberPage> {
  List<V2TimFriendInfo> selectedContacter = [];

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return Scaffold(
        appBar: AppBar(
            title: Text(
              TIM_t("添加群成员"),
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (selectedContacter.isNotEmpty) {
                    final userIDs =
                        selectedContacter.map((e) => e.userID).toList();
                    await widget.model.inviteUserToGroup(userIDs);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  TIM_t("确定"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
            shadowColor: theme.weakDividerColor,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  theme.lightPrimaryColor ?? CommonColor.lightPrimaryColor,
                  theme.primaryColor ?? CommonColor.primaryColor
                ]),
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            )),
        body: ChangeNotifierProvider.value(
            value: widget.model,
            child: Consumer<TUIGroupProfileViewModel>(
                builder: ((context, value, child) {
              if (value.contactList != null) {
                return ContactList(
                  contactList: value.contactList!,
                  isCanSelectMemberItem: true,
                  onSelectedMemberItemChange: (selectedMember) {
                    selectedContacter = selectedMember;
                  },
                );
              }
              return Container();
            }))));
  }
}