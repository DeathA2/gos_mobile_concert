import 'package:mobile_concert/src/network/model/post.dart';
import 'package:mobile_concert/src/network/model/user.dart';

class MockData {
  static List<Post> listPost = [
    Post(
      id: "post_0",
      content: "Hi everybody",
      medias: [],
      isStream: false,
      createAt: DateTime.now().subtract(Duration(days: 1)),
      owner: listUser[1],
    ),

      Post(
      id: "post_1",
      content: "Hi nobody",
      medias: [
                "https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/500426432_2563513020664851_3109461176532767756_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=ByD_l3_LsLEQ7kNvwF5nrqB&_nc_oc=AdkVsI3skXDtWF2wcGRRFeAf-YvvwD4UAdIeKW82sZXSTVHrfEDxhIHibyAJ13epXe6SLnVZbqFpmYUM9-Jmicke&_nc_zt=23&_nc_ht=scontent.fsgn2-11.fna&_nc_gid=t8yOqjUVGxlbXRI29F9bzg&oh=00_AffdSkDXExMJ7kEgX6rovZTmg7B-a0pGn8CT7V1sSfCHdQ&oe=69055C9E",
        "https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/500426432_2563513020664851_3109461176532767756_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=ByD_l3_LsLEQ7kNvwF5nrqB&_nc_oc=AdkVsI3skXDtWF2wcGRRFeAf-YvvwD4UAdIeKW82sZXSTVHrfEDxhIHibyAJ13epXe6SLnVZbqFpmYUM9-Jmicke&_nc_zt=23&_nc_ht=scontent.fsgn2-11.fna&_nc_gid=t8yOqjUVGxlbXRI29F9bzg&oh=00_AffdSkDXExMJ7kEgX6rovZTmg7B-a0pGn8CT7V1sSfCHdQ&oe=69055C9E",
        "https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/497863430_2553066201709533_93243012629375990_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=8yMcIZRqbksQ7kNvwGfZgXt&_nc_oc=AdkTJMoEtvAfKEThGpAZuCbeAp9aY9a3hEmxElXPsIOgSb9fpeIceH3rqJ9XRvtLkcJ6RwnJaORe3xmdQ1iD5Nr8&_nc_zt=23&_nc_ht=scontent.fsgn2-11.fna&_nc_gid=qzj2yLxHy_ltuegS415_yw&oh=00_AfcQ8ywp1BKrqKC9q_LIu1k2cgJWYu2vM5y1gIzG3NyMfQ&oe=690576E9",
        "https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/497863430_2553066201709533_93243012629375990_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=8yMcIZRqbksQ7kNvwGfZgXt&_nc_oc=AdkTJMoEtvAfKEThGpAZuCbeAp9aY9a3hEmxElXPsIOgSb9fpeIceH3rqJ9XRvtLkcJ6RwnJaORe3xmdQ1iD5Nr8&_nc_zt=23&_nc_ht=scontent.fsgn2-11.fna&_nc_gid=qzj2yLxHy_ltuegS415_yw&oh=00_AfcQ8ywp1BKrqKC9q_LIu1k2cgJWYu2vM5y1gIzG3NyMfQ&oe=690576E9",
      ],
      isStream: false,
      createAt: DateTime.now().subtract(Duration(hours: 1)),
      owner: listUser[0],
    ),
  ];

  static List<User> listUser = [
    User(id: "user_0", name: "Lance'mark", avatar: ""),
    User(id: "user_1", name: "Leon 'Subin' Nguyen", avatar: ""),
    User(id: "user_2", name: "Anh Luke", avatar: ""),
    User(id: "user_3", name: "Maven Le", avatar: ""),
    User(id: "user_4", name: "Chad Dinh", avatar: ""),
    User(id: "user_5", name: "Nuo'l'c Tran", avatar: ""),
  ];
}
