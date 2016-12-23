import tensorflow as tf
from sklearn.cross_validation import train_test_split

dataset, validation = train_test_split(dataset, test_size = 0.1)
train, test = train_test_split(dataset, test_size = 0.1)
print 'train:', train.shape, 'validation:', validation.shape, 'test:', test.shape

sess = tf.InteractiveSession()


#input/output placeholders
x_dire    = tf.placeholder("float", shape=[None, 113], name='x_dire')
x_radiant = tf.placeholder("float", shape=[None, 113], name='x_radiant')
y_        = tf.placeholder("float", shape=[None, 2], name='y_true')

#we'll use dropout layers for regularisation which need a keep probability
keep_prob1 = tf.placeholder("float", name='keep_prob1')
keep_prob2 = tf.placeholder("float", name='keep_prob2')

#there doesn't seem to be any other way to differenciate train and validation summaries for TensorBoard
loss_name     = tf.placeholder("string", name='loss_name')
accuracy_name = tf.placeholder("string", name='accuracy_name')


def fc_weight_bias(in_size, out_size):
    initial_weight = tf.truncated_normal([in_size, out_size], stddev=0.2, mean=0.0)
    initial_bias = tf.constant(0.1, shape=[out_size])
    return tf.Variable(initial_weight), tf.Variable(initial_bias)

#first hero layer
with tf.name_scope("hero_layers_1") as scope:
    W_hero1, b_hero1 = fc_weight_bias(113,80)
    #note that dire layer and radiant layer use the same weights and biases
    dire_layer1 = tf.nn.relu(tf.matmul(x_dire, W_hero1) + b_hero1)
    radiant_layer1 = tf.nn.relu(tf.matmul(x_radiant, W_hero1) + b_hero1)

#second hero layer
with tf.name_scope("hero_layers_2") as scope:
    W_hero2, b_hero2 = fc_weight_bias(80,80)
    #again, dire and radiant use the same weights and biases
    dire_layer2 = tf.nn.relu(tf.matmul(dire_layer1, W_hero2) + b_hero2)
    radiant_layer2 = tf.nn.relu(tf.matmul(radiant_layer1, W_hero2) + b_hero2)

#now concatenate the dire and radiant team outputs
with tf.name_scope("hero_layers_concat") as scope:
    dire_radiant_concat = tf.concat(1, [dire_layer2, radiant_layer2])
    dire_radiant_drop = tf.nn.dropout(dire_radiant_concat, keep_prob1)
    h_drop1 = tf.nn.dropout(dire_radiant_drop, keep_prob1)

with tf.name_scope("hidden_layer_1") as scope:
    W_hidden1, b_hidden1 = fc_weight_bias(160,120)
    h_hidden1 = tf.nn.relu(tf.matmul(h_drop1, W_hidden1) + b_hidden1)
    h_drop2 = tf.nn.dropout(h_hidden1, keep_prob2)

with tf.name_scope("hidden_layer_2") as scope:
    W_hidden2, b_hidden2 = fc_weight_bias(120,75)
    h_hidden2 = tf.nn.relu(tf.matmul(h_drop2, W_hidden2) + b_hidden2)

with tf.name_scope("hidden_layer_3") as scope:
    W_hidden3, b_hidden3 = fc_weight_bias(75,25)
    h_hidden3 = tf.nn.relu(tf.matmul(h_hidden2, W_hidden3) + b_hidden3)


with tf.name_scope("output_layer") as scope:
    W_hidden4, b_hidden4 = fc_weight_bias(25,2)
    y = tf.nn.softmax(tf.matmul(h_hidden3, W_hidden4) + b_hidden4)


with tf.name_scope("loss_calculations") as scope:
    cross_entropy = -tf.reduce_sum(y_ * tf.log(y + 1e-8))
    weights_sum   = tf.add_n([tf.nn.l2_loss(variable) for variable in tf.all_variables()])
    loss          = cross_entropy + weights_sum
    mean_loss     = tf.reduce_mean(loss)

with tf.name_scope("trainer") as scope:
    train_step    = tf.train.AdamOptimizer(0.0001).minimize(loss)

with tf.name_scope("accuracy_calculations") as scope:
    correct  = tf.equal(tf.argmax(y, 1), tf.argmax(y_, 1))
    accuracy = tf.reduce_mean(tf.cast(correct, "float"))


#summarize the accuracy and loss
accuracy_summary = tf.scalar_summary(accuracy_name, accuracy)
mean_loss_summary = tf.scalar_summary(loss_name, mean_loss)

#summarize the distribution of output values
y_hist = tf.histogram_summary("y", y)

#gather all summaries
merged = tf.merge_all_summaries()

writer = tf.train.SummaryWriter("logdir", sess.graph_def)

sess.run(tf.initialize_all_variables())



def get_data_feed(dataset, kp1=1.0, kp2=1.0, loss_str='loss', accuracy_str='accuracy'):
    radiant_data, dire_data = dataset.ix[:,:113], dataset.ix[:,113:226]
    winners = pd.get_dummies(dataset['radiant_win'])
    return {
        x_radiant: radiant_data,
        x_dire: dire_data,
        y_: winners,
        loss_name: loss_str,
        accuracy_name: accuracy_str,
        keep_prob1: kp1,
        keep_prob2: kp2
    }

train_feed      = get_data_feed(train,      loss_str = 'loss_train',      accuracy_str = 'accuracy_train')
validation_feed = get_data_feed(validation, loss_str = 'loss_validation', accuracy_str = 'accuracy_validation')
test_feed       = get_data_feed(test,       loss_str = 'loss_test',       accuracy_str = 'accuracy_test')


def get_batches(dataset, batch_size=512):
    #randomise before every epoch
    dataset = dataset.take(np.random.permutation(len(dataset)))

    i = 0
    while i < len(dataset):
        yield dataset[i : i + batch_size]
        i = i + batch_size

for i in range(100):
    for mini_batch in get_batches(train):
        mini_batch_feed = get_data_feed(mini_batch, 0.5, 0.5)
        train_step.run(feed_dict = mini_batch_feed)

    #log every epoch
    train_loss          = loss.eval(feed_dict = train_feed)
    validation_loss     = loss.eval(feed_dict = validation_feed)

    train_accuracy      = accuracy.eval(feed_dict = train_feed)
    validation_accuracy = accuracy.eval(feed_dict = validation_feed)

    train_summary_str      = merged.eval(feed_dict = train_feed)
    validation_summary_str = merged.eval(feed_dict = validation_feed)

    writer.add_summary(train_summary_str, i)
    writer.add_summary(validation_summary_str, i)
    print("epoch %d, loss: %g, train: %g, validation: %g"% (i, train_loss, train_accuracy, validation_accuracy))

writer.close()

accuracy.eval(feed_dict=test_feed)
