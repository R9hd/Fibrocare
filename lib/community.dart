import 'package:fibercare/homepage.dart';
import 'package:fibercare/language_manager.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final TextEditingController _postController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _currentUsername = 'Loading...';
  String _currentUserId = '';
  bool _isPosting = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _postController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _postController.removeListener(_updateButtonState);
    _postController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = _auth.currentUser!;
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      setState(() {
        _currentUserId = user.uid;
        _currentUsername = userDoc.data()?['username'] as String? ??
            user.displayName ??
            user.email?.split('@').first ??
            'User${user.uid.substring(0, 5)}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentUsername = 'Anonymous';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary; // dark blue
    Color tertiary = Theme.of(context).colorScheme.tertiary; // light blue
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(languageManager.translate('supportCommunity'), style: TextStyle(color: tertiary)),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tertiary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Homepage()),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFd4e8eb),
      body: Column(
        children: [
          Expanded(child: _buildPostsList()),
          _buildPostInput(),
        ],
      ),
    );
  }

  Widget _buildPostsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['timestamp'] != null;
        }).toList();

        if (posts.isEmpty) {
          return const Center(
              child: Text('No posts yet. Be the first to share!'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final data = post.data() as Map<String, dynamic>;
            final timestamp = data['timestamp'] as Timestamp? ?? Timestamp.now();
            final likedBy = List<String>.from(data['likedBy'] ?? []);
            final isLiked = likedBy.contains(_currentUserId);
            final isCurrentUserPost = data['userId'] == _currentUserId;

            return PostWidget(
              postId: post.id,
              content: data['content']?.toString() ?? '',
              likes: (data['likes'] as int?) ?? 0,
              isLiked: isLiked,
              timestamp: timestamp.toDate(),
              username: data['username']?.toString() ?? 'Anonymous',
              onLike: () => _toggleLike(post.id, likedBy),
              onDelete: isCurrentUserPost ? () => _deletePost(post.id) : null,
              isCurrentUserPost: isCurrentUserPost,
            );
          },
        );
      },
    );
  }

  Widget _buildPostInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: languageManager.translate('whatDoYouThink'),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          const SizedBox(width: 8),
          _isPosting
              ? const CircularProgressIndicator()
              : IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 28,
                    color: _postController.text.trim().isEmpty
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                  ),
                  onPressed:
                      _postController.text.trim().isEmpty ? null : _addPost,
                ),
        ],
      ),
    );
  }

  Future<void> _addPost() async {
    if (_postController.text.trim().isEmpty) return;

    setState(() => _isPosting = true);

    try {
      await _firestore.collection('posts').add({
        'content': _postController.text,
        'likes': 0,
        'likedBy': [],
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _currentUserId,
        'username': _currentUsername,
      });
      _postController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isPosting = false);
    }
  }

  Future<void> _toggleLike(String postId, List<String> likedBy) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': likedBy.contains(_currentUserId)
            ? FieldValue.increment(-1)
            : FieldValue.increment(1),
        'likedBy': likedBy.contains(_currentUserId)
            ? FieldValue.arrayRemove([_currentUserId])
            : FieldValue.arrayUnion([_currentUserId]),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to like: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post deleted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete post: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class PostWidget extends StatelessWidget {
  final String postId;
  final String content;
  final int likes;
  final bool isLiked;
  final DateTime timestamp;
  final String username;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final bool isCurrentUserPost;

  const PostWidget({
    super.key,
    required this.postId,
    required this.content,
    required this.likes,
    required this.isLiked,
    required this.timestamp,
    required this.username,
    required this.onLike,
    this.onDelete,
    required this.isCurrentUserPost,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(username[0].toUpperCase()),
                ),
                const SizedBox(width: 8),
                Text(
                  '@$username',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                if (isCurrentUserPost)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(context),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: onLike,
                ),
                Text(
                  likes.toString(),
                  style: TextStyle(
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(timestamp),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text(languageManager.translate('deletePost')),
        content: Text(languageManager.translate('areYouSureYouWantToDelete')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(languageManager.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: Text(languageManager.translate('delete'), style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = timestamp.difference(now).abs();

    if (difference.inSeconds < 60) return '${difference.inSeconds}s ago';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 30) return '${difference.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}