import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_polls/Providers/db_provider.dart';
import 'package:my_polls/Providers/fetch_polls_provider.dart';
import 'package:my_polls/Styles/colors.dart';
import 'package:my_polls/Utils/dynamic_utils.dart';
import 'package:my_polls/Utils/message.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFetched = false;

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FetchPollsProvider>(builder: (context, polls, child) {
        if (_isFetched == false) {
          polls.fetchAllPolls();

          Future.delayed(const Duration(microseconds: 1), () {
            _isFetched = true;
          });
        }
        return SafeArea(
          child: polls.isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : polls.pollsList.isEmpty
                  ? const Center(
                      child: Text("No polls at the moment"),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                ...List.generate(polls.pollsList.length,
                                    (index) {
                                  final data = polls.pollsList[index];

                                  log(data.data().toString());
                                  Map author = data["author"];
                                  Map poll = data["poll"];
                                  Timestamp date = data["dateCreated"];

                                  List voters = poll["voters"];

                                  List<dynamic> options = poll["options"];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                author["profileImage"]),
                                          ),
                                          title: Text(author["name"]),
                                          subtitle: Text(DateFormat.yMEd()
                                              .format(date.toDate())),
                                          trailing: IconButton(
                                              onPressed: () {
                                                ///
                                                DynamicLinkProvider()
                                                    .createLink(data.id)
                                                    .then((value) {
                                                  Share.share(value);
                                                });
                                              },
                                              icon: const Icon(Icons.share)),
                                        ),
                                        Text(poll["question"]),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        ...List.generate(options.length,
                                            (index) {
                                          final dataOption = options[index];
                                          return Consumer<DbProvider>(
                                              builder: (context, vote, child) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                              (_) {
                                                if (vote.message != "") {
                                                  if (vote.message.contains(
                                                      "Vote Recorded")) {
                                                    success(context,
                                                        message: vote.message);
                                                    polls.fetchAllPolls();
                                                    vote.clear();
                                                  } else {
                                                    error(context,
                                                        message: vote.message);
                                                    vote.clear();
                                                  }
                                                }
                                              },
                                            );
                                            return GestureDetector(
                                              onTap: () {
                                                log(user!.uid);

                                                ///Update vote
                                                if (voters.isEmpty) {
                                                  log("No vote");
                                                  vote.votePoll(
                                                      pollId: data.id,
                                                      pollData: data,
                                                      previousTotalVotes:
                                                          poll["total_votes"],
                                                      seletedOptions:
                                                          dataOption["answer"]);
                                                } else {
                                                  final isExists =
                                                      voters.firstWhere(
                                                          (element) =>
                                                              element["uid"] ==
                                                              user!.uid,
                                                          orElse: () {});
                                                  if (isExists == null) {
                                                    log("User does not exist");
                                                    vote.votePoll(
                                                        pollId: data.id,
                                                        pollData: data,
                                                        previousTotalVotes:
                                                            poll["total_votes"],
                                                        seletedOptions:
                                                            dataOption[
                                                                "answer"]);
                                                    //
                                                  } else {
                                                    error(context,
                                                        message:
                                                            "You have already voted");
                                                  }
                                                  print(isExists.toString());
                                                }
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Stack(
                                                        children: [
                                                          LinearProgressIndicator(
                                                            minHeight: 30,
                                                            value: dataOption[
                                                                    "percent"] /
                                                                100,
                                                            backgroundColor:
                                                                AppColors.white,
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            height: 30,
                                                            child: Text(
                                                                dataOption[
                                                                    "answer"]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                        "${dataOption["percent"]}%")
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                        }),
                                        Text(
                                            "Total votes : ${poll["total_votes"]}")
                                      ],
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
        );
      }),
    );
  }
}
