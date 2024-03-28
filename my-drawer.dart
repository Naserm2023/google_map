import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
   MyDrawer({super.key});

   final Uri facebook = Uri.parse('https://www.facebook.com/naser.aloka');
   final Uri instagram = Uri.parse('https://www.instagram.com/eng.naser_aloka/?hl=ar');
   final Uri telegram = Uri.parse('https://t.me/naser_aloka');


   Widget buildDrawerHeader(context){
    return Container(
     // padding:const EdgeInsetsDirectional.fromSTEB(30, 5, 30, 5),
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: Image.asset("images/person.png",fit: BoxFit.cover,),
    );
  }

  Widget buildDrawerListItem({required IconData leadingIcon , required String title , Widget? trailing ,
    Function()? onTap , Color? color})
  {
    return ListTile(
      leading:Icon(leadingIcon,color: color ?? Colors.blue,),
      title: Text(title),
      trailing:trailing ??const Icon(Icons.arrow_right , color: Colors.blue,) ,
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemDivider(){
    return const Divider(
      height: 0,
      thickness: 1,
      indent: 18,
      endIndent: 24,
    );
  }

   Future<void> _launchUrl(url) async {
     if (!await launchUrl(url)) {
       throw Exception('Could not launch $url');
     }
   }

  // Widget buildIcon(IconData icon , String url){
  //   return InkWell(
  //     onTap: () => _launchUrl(url),
  //     child: Icon(icon , color: Colors.blue,size: 30,),
  //   );
  // }


  Widget buildSocialMediaIcons(){
    return Padding(
      padding:const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [

          IconButton(
         icon:const Icon(FontAwesomeIcons.facebook) ,
            onPressed: () {
              _launchUrl(facebook);
            },
            color: Colors.blue,
            iconSize: 30,
          ),

          IconButton(
            icon:const Icon(FontAwesomeIcons.instagram) ,
            onPressed: () {
              _launchUrl(instagram);
            },
            color: Colors.blue,
            iconSize: 30,
          ),

          IconButton(
            icon:const Icon(FontAwesomeIcons.telegram) ,
            onPressed: () {
              _launchUrl(telegram);
            },
            color: Colors.blue,
            iconSize: 30,
          ),


        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 280,
            child: DrawerHeader(decoration: const BoxDecoration(color: Colors.white),
              child: buildDrawerHeader(context),),
          ),

          buildDrawerListItem(leadingIcon: Icons.person, title: 'My Profile'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(leadingIcon: Icons.history, title: 'Places History' ,onTap: () {},),
          buildDrawerListItemDivider(),
          buildDrawerListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDrawerListItemDivider(),
          const SizedBox(height: 180),
          ListTile(
            leading: Text("Follow us",style: TextStyle(color: Colors.grey[600]),),
          ),
          buildSocialMediaIcons(),


        ],
      ),
    );
  }
}
