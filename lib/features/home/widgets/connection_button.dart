import 'package:flutter/material.dart';

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.available,
  });

  final Widget icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final bool? available;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withAlpha(50),
          width: 1,
        ),
      ),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(
                width: 40,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    available != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(available == true
                                  ? 'Available'
                                  : 'Not available'),
                              const SizedBox(width: 4),
                              if (available == true)
                                const Icon(Icons.check_circle,
                                    size: 16, color: Colors.green),
                              if (available == false)
                                const Icon(Icons.remove_circle_outlined,
                                    size: 16, color: Colors.red),
                            ],
                          )
                        : Text(subTitle)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
