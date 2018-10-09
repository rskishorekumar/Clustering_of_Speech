# Clustering_of_Speech

We have developed this method for the purpose of segregating the large volume of speech repositories into clusters where each cluster represents the utterances related to some broader domain at semantic level. For example if the speech repository consist of news bulletins, the output clusters representing the broader domains such as politics, social, sports and weather. 

The above source codes are implemented in a manuscript titled "A Robust Unsupervised Pattern Discovery and Clustering of Speech Signals" by Kishore Kumar R, Lokendra Birla, K Sreenivasa Rao submitted. 

The souce code which is shared here will detect the desired keyword/phrase candidate matched between the pair of speech utterances. The input to out method is the posterior features of the speech utterances and the output is the matched time stamps between a pair of speech utterance. More details below:

(i) Initially for all the speech utterances (/WAV/ (folder)) in the speech corpora the MFCC features vectors are extracted in /MFCC/ folder with 25 ms framesize and 10ms frame shift. 
(ii) The extracted MFCC features are given to GMM for train an acoutic model and the posterior features for the same is extracted in /posterior/MFCC/ folder. 
(iii) The /matlab/ folder contains the code for performing the above task of detect the matched keyword of phrase between the pair of speech utterances (Spotingkeywordmatchingindocument_f.m). Inturn the program (Spotingkeywordmatchingindocument_f.m) will  call the distance function (newnomKLSDiv.m) for computing the similarity matrix between a pair of speech utterances. The details of the method is given in detail in the above manuscript. The algorithm generates the matched time stamps between all pairs of speech utterances. 
(iv) This matched information between the speech utterances is devised as an adjacency matrix and this matrix is given as input to the Newman clustering algorithm. The clustering algorithm outputs clusters representing the broader groups of speech utterances at semantic level. 

Usage:

Now, placing all the corresponding feature files in their respective directories run the following command in matlab command promt as:

Spotingkeywordmatchingindocument_f.m

The method outputs the matching time stamps between the speech utterances. 

Source code is tested in Matlab 2016B, Linux Environment.

