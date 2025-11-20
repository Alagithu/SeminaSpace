import 'package:flutter/material.dart';

class ItemHome extends StatelessWidget {
  const ItemHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("1500dt par jours"),
            subtitle: Text("Surface:300 m"),
            trailing: Icon(Icons.favorite_outline),
          ),
          Container(child: Image.asset("assets/semina1.jpg")),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "Situé à Sousse, à moins de 700 métres de la gare du Nord et à moins de 1 km de la gare de l'Est",
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: OverflowBar(
              overflowAlignment: OverflowBarAlignment.end,
              children: [
                TextButton(
                  onPressed: () => {},
                  child: Text("Vérifier la disponibilité"),
                ),
                TextButton(onPressed: () => {}, child: Text("Contactez Nous")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemHome2 extends StatelessWidget {
  const ItemHome2({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("1200dt par jours"),
            subtitle: Text("Surface:250 m"),
            trailing: Icon(Icons.favorite_outline),
          ),
          Container(child: Image.asset("assets/semina2.jpg")),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "Situé à Monastir, à moins de 700 métres de la gare du Nord et à moins de 1 km de la gare de l'Est",
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: OverflowBar(
              overflowAlignment: OverflowBarAlignment.end,
              children: [
                TextButton(
                  onPressed: () => {},
                  child: Text("Vérifier la disponibilité"),
                ),
                TextButton(onPressed: () => {}, child: Text("Contactez Nous")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemHome3 extends StatelessWidget {
  const ItemHome3({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("1800dt par jours"),
            subtitle: Text("Surface:400 m"),
            trailing: Icon(Icons.favorite_outline),
          ),
          Container(child: Image.asset("assets/semina3.jpg")),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "Situé à Mahdia, à moins de 700 métres de la gare du Nord et à moins de 1 km de la gare de l'Est",
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: OverflowBar(
              overflowAlignment: OverflowBarAlignment.end,
              children: [
                TextButton(
                  onPressed: () => {},
                  child: Text("Vérifier la disponibilité"),
                ),
                TextButton(onPressed: () => {}, child: Text("Contactez Nous")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemHome4 extends StatelessWidget {
  const ItemHome4({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("800dt par jours"),
            subtitle: Text("Surface:200 m"),
            trailing: Icon(Icons.favorite_outline),
          ),
          Container(child: Image.asset("assets/semina4.jpg")),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "Situé à Tunis, à moins de 700 métres de la gare du Nord et à moins de 1 km de la gare de l'Est",
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: OverflowBar(
              overflowAlignment: OverflowBarAlignment.end,
              children: [
                TextButton(
                  onPressed: () => {},
                  child: Text("Vérifier la disponibilité"),
                ),
                TextButton(onPressed: () => {}, child: Text("Contactez Nous")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
