import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/community.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/community/view_page.dart';
import 'package:workout_helper/pages/general/navigate_app_bar.dart';
import 'package:workout_helper/service/community_service.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'editor_page.dart';

class CommunityMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CommunityMainState();
  }
}

class CommunityMainState extends State<CommunityMain> {
  List<Post> posts = List();

  CommunityService _communityService;

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  User _currentUser;

  bool inLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!this.mounted) {
      return;
    }
    _communityService = CommunityService(_key);
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    _communityService.getViewablePost(_currentUser).then((list) {
      setState(() {
        inLoading = false;
        posts = list;
      });
    }).catchError((_) {
      setState(() {
        inLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: NavigateAppBar(currentPage: 1,),
      body: SafeArea(
          child: inLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : posts == null || posts.isEmpty
                  ? Container()
                  : ListView.separated(
                      itemCount: posts?.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        Post p = posts.elementAt(index);

                        return ListTile(
                          title: Text(p.title),
                          subtitle: Text(p.postBy.name +
                              " 于 " +
                              DateFormat('yyyy-MM-dd hh:mm:ss')
                                  .format(p.postAt.add(Duration(hours: 8)))),
                          onTap: () {
                            _communityService.getPost(p.id).then((updatePost) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ViewPage(
                                        post: updatePost,
                                      )));
                            });
                          },
                        );
                      },
                    )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          NavigationUtil.pushUsingDefaultFadingTransition(
              context, EditorPage());
        },
        child: Icon(
          Icons.add_comment,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
