PGDMP  1    '    	            }         	   xpectro-2     17.2 (Ubuntu 17.2-1.pgdg20.04+1)    17.2 a   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    54974 	   xpectro-2    DATABASE     s   CREATE DATABASE "xpectro-2" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE "xpectro-2";
                     xpectro    false                        3079    54980 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                        false            �           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                             false    2            �           1259    55532 
   Announcements    TABLE     b  CREATE TABLE public."Announcements" (
    id integer NOT NULL,
    priority integer,
    title character varying(255) NOT NULL,
    text text NOT NULL,
    "mediaPath" text,
    "mediaName" text,
    "companyId" integer NOT NULL,
    status boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 #   DROP TABLE public."Announcements";
       public         heap r       xpectro    false            �           1259    55531    Announcements_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Announcements_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."Announcements_id_seq";
       public               xpectro    false    470            �           0    0    Announcements_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."Announcements_id_seq" OWNED BY public."Announcements".id;
          public               xpectro    false    469            �           1259    55407    Baileys    TABLE     �   CREATE TABLE public."Baileys" (
    id integer NOT NULL,
    "whatsappId" integer NOT NULL,
    contacts text,
    chats text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public."Baileys";
       public         heap r       xpectro    false            �           1259    55642    BaileysChats    TABLE     K  CREATE TABLE public."BaileysChats" (
    id integer NOT NULL,
    "whatsappId" integer,
    jid character varying(255) NOT NULL,
    "conversationTimestamp" character varying(255) NOT NULL,
    "unreadCount" integer DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 "   DROP TABLE public."BaileysChats";
       public         heap r       xpectro    false            �           1259    55641    BaileysChats_id_seq    SEQUENCE     �   CREATE SEQUENCE public."BaileysChats_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."BaileysChats_id_seq";
       public               xpectro    false    482            �           0    0    BaileysChats_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."BaileysChats_id_seq" OWNED BY public."BaileysChats".id;
          public               xpectro    false    481            �           1259    55657    BaileysMessages    TABLE       CREATE TABLE public."BaileysMessages" (
    id integer NOT NULL,
    "whatsappId" integer,
    "baileysChatId" integer,
    "jsonMessage" json NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 %   DROP TABLE public."BaileysMessages";
       public         heap r       xpectro    false            �           1259    55656    BaileysMessages_id_seq    SEQUENCE     �   CREATE SEQUENCE public."BaileysMessages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."BaileysMessages_id_seq";
       public               xpectro    false    484            �           0    0    BaileysMessages_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."BaileysMessages_id_seq" OWNED BY public."BaileysMessages".id;
          public               xpectro    false    483            �           1259    55406    Baileys_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Baileys_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."Baileys_id_seq";
       public               xpectro    false    457            �           0    0    Baileys_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."Baileys_id_seq" OWNED BY public."Baileys".id;
          public               xpectro    false    456            �           1259    55483    CampaignSettings    TABLE     �   CREATE TABLE public."CampaignSettings" (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 &   DROP TABLE public."CampaignSettings";
       public         heap r       xpectro    false            �           1259    55482    CampaignSettings_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CampaignSettings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public."CampaignSettings_id_seq";
       public               xpectro    false    465            �           0    0    CampaignSettings_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."CampaignSettings_id_seq" OWNED BY public."CampaignSettings".id;
          public               xpectro    false    464            �           1259    55504    CampaignShipping    TABLE       CREATE TABLE public."CampaignShipping" (
    id integer NOT NULL,
    "jobId" character varying(255),
    number character varying(255) NOT NULL,
    message text NOT NULL,
    "confirmationMessage" text,
    confirmation boolean,
    "contactId" integer,
    "campaignId" integer NOT NULL,
    "confirmationRequestedAt" timestamp with time zone,
    "confirmedAt" timestamp with time zone,
    "deliveredAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 &   DROP TABLE public."CampaignShipping";
       public         heap r       xpectro    false            �           1259    55503    CampaignShipping_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CampaignShipping_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public."CampaignShipping_id_seq";
       public               xpectro    false    468            �           0    0    CampaignShipping_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."CampaignShipping_id_seq" OWNED BY public."CampaignShipping".id;
          public               xpectro    false    467            �           1259    55448 	   Campaigns    TABLE     �  CREATE TABLE public."Campaigns" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    message1 text DEFAULT ''::text,
    message2 text DEFAULT ''::text,
    message3 text DEFAULT ''::text,
    message4 text DEFAULT ''::text,
    message5 text DEFAULT ''::text,
    "confirmationMessage1" text DEFAULT ''::text,
    "confirmationMessage2" text DEFAULT ''::text,
    "confirmationMessage3" text DEFAULT ''::text,
    "confirmationMessage4" text DEFAULT ''::text,
    "confirmationMessage5" text DEFAULT ''::text,
    status character varying(255),
    confirmation boolean DEFAULT false,
    "mediaPath" text,
    "mediaName" text,
    "companyId" integer NOT NULL,
    "contactListId" integer,
    "whatsappId" integer,
    "scheduledAt" timestamp with time zone,
    "completedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "fileListId" integer,
    "tagId" integer
);
    DROP TABLE public."Campaigns";
       public         heap r       xpectro    false            �           1259    55447    Campaigns_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Campaigns_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."Campaigns_id_seq";
       public               xpectro    false    463            �           0    0    Campaigns_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."Campaigns_id_seq" OWNED BY public."Campaigns".id;
          public               xpectro    false    462            �           1259    55585    ChatMessages    TABLE     5  CREATE TABLE public."ChatMessages" (
    id integer NOT NULL,
    "chatId" integer NOT NULL,
    "senderId" integer NOT NULL,
    message text DEFAULT ''::text,
    "mediaPath" text,
    "mediaName" text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 "   DROP TABLE public."ChatMessages";
       public         heap r       xpectro    false            �           1259    55584    ChatMessages_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ChatMessages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."ChatMessages_id_seq";
       public               xpectro    false    476            �           0    0    ChatMessages_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."ChatMessages_id_seq" OWNED BY public."ChatMessages".id;
          public               xpectro    false    475            �           1259    55567 	   ChatUsers    TABLE        CREATE TABLE public."ChatUsers" (
    id integer NOT NULL,
    "chatId" integer NOT NULL,
    "userId" integer NOT NULL,
    unreads integer DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public."ChatUsers";
       public         heap r       xpectro    false            �           1259    55566    ChatUsers_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ChatUsers_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."ChatUsers_id_seq";
       public               xpectro    false    474            �           0    0    ChatUsers_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."ChatUsers_id_seq" OWNED BY public."ChatUsers".id;
          public               xpectro    false    473            �           1259    55546    Chats    TABLE     Y  CREATE TABLE public."Chats" (
    id integer NOT NULL,
    title text DEFAULT ''::text,
    uuid character varying(255) DEFAULT ''::character varying,
    "ownerId" integer NOT NULL,
    "lastMessage" text,
    "companyId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public."Chats";
       public         heap r       xpectro    false            �           1259    55545    Chats_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Chats_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."Chats_id_seq";
       public               xpectro    false    472            �           0    0    Chats_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."Chats_id_seq" OWNED BY public."Chats".id;
          public               xpectro    false    471            �           1259    55140 	   Companies    TABLE     �  CREATE TABLE public."Companies" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    phone character varying(255),
    email character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "planId" integer,
    status boolean DEFAULT true,
    schedules jsonb DEFAULT '[]'::jsonb,
    "dueDate" timestamp with time zone,
    recurrence character varying(255) DEFAULT ''::character varying
);
    DROP TABLE public."Companies";
       public         heap r       xpectro    false            �           1259    55139    Companies_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Companies_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."Companies_id_seq";
       public               xpectro    false    436            �           0    0    Companies_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."Companies_id_seq" OWNED BY public."Companies".id;
          public               xpectro    false    435            �           1259    55060    ContactCustomFields    TABLE     $  CREATE TABLE public."ContactCustomFields" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    "contactId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 )   DROP TABLE public."ContactCustomFields";
       public         heap r       xpectro    false            �           1259    55059    ContactCustomFields_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ContactCustomFields_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."ContactCustomFields_id_seq";
       public               xpectro    false    429            �           0    0    ContactCustomFields_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."ContactCustomFields_id_seq" OWNED BY public."ContactCustomFields".id;
          public               xpectro    false    428            �           1259    55428    ContactListItems    TABLE     �  CREATE TABLE public."ContactListItems" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    number character varying(255) NOT NULL,
    email character varying(255),
    "contactListId" integer NOT NULL,
    "isWhatsappValid" boolean DEFAULT false,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 &   DROP TABLE public."ContactListItems";
       public         heap r       xpectro    false            �           1259    55427    ContactListItems_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ContactListItems_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public."ContactListItems_id_seq";
       public               xpectro    false    461            �           0    0    ContactListItems_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."ContactListItems_id_seq" OWNED BY public."ContactListItems".id;
          public               xpectro    false    460            �           1259    55416    ContactLists    TABLE     �   CREATE TABLE public."ContactLists" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 "   DROP TABLE public."ContactLists";
       public         heap r       xpectro    false            �           1259    55415    ContactLists_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ContactLists_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."ContactLists_id_seq";
       public               xpectro    false    459            �           0    0    ContactLists_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."ContactLists_id_seq" OWNED BY public."ContactLists".id;
          public               xpectro    false    458            �           1259    55003    Contacts    TABLE     �  CREATE TABLE public."Contacts" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    number character varying(255) NOT NULL,
    "profilePicUrl" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    "isGroup" boolean DEFAULT false NOT NULL,
    "companyId" integer,
    "whatsappId" integer
);
    DROP TABLE public."Contacts";
       public         heap r       xpectro    false            �           1259    55002    Contacts_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Contacts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."Contacts_id_seq";
       public               xpectro    false    422            �           0    0    Contacts_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."Contacts_id_seq" OWNED BY public."Contacts".id;
          public               xpectro    false    421            �           1259    55705    Files    TABLE       CREATE TABLE public."Files" (
    id integer NOT NULL,
    "companyId" integer NOT NULL,
    name character varying(255) NOT NULL,
    message text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public."Files";
       public         heap r       xpectro    false            �           1259    55719    FilesOptions    TABLE     _  CREATE TABLE public."FilesOptions" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    path character varying(255) NOT NULL,
    "fileId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "mediaType" character varying(255) DEFAULT ''::character varying
);
 "   DROP TABLE public."FilesOptions";
       public         heap r       xpectro    false            �           1259    55718    FilesOptions_id_seq    SEQUENCE     �   CREATE SEQUENCE public."FilesOptions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."FilesOptions_id_seq";
       public               xpectro    false    490            �           0    0    FilesOptions_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."FilesOptions_id_seq" OWNED BY public."FilesOptions".id;
          public               xpectro    false    489            �           1259    55704    Files_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Files_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."Files_id_seq";
       public               xpectro    false    488            �           0    0    Files_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."Files_id_seq" OWNED BY public."Files".id;
          public               xpectro    false    487            �           1259    55243    Helps    TABLE       CREATE TABLE public."Helps" (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    video character varying(255),
    link text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public."Helps";
       public         heap r       xpectro    false            �           1259    55242    Helps_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Helps_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."Helps_id_seq";
       public               xpectro    false    444            �           0    0    Helps_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."Helps_id_seq" OWNED BY public."Helps".id;
          public               xpectro    false    443            �           1259    55626    Invoices    TABLE     C  CREATE TABLE public."Invoices" (
    id integer NOT NULL,
    detail character varying(255),
    status character varying(255),
    value double precision,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "dueDate" character varying(255),
    "companyId" integer
);
    DROP TABLE public."Invoices";
       public         heap r       xpectro    false            �           1259    55625    Invoices_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Invoices_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."Invoices_id_seq";
       public               xpectro    false    480                        0    0    Invoices_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."Invoices_id_seq" OWNED BY public."Invoices".id;
          public               xpectro    false    479            �           1259    55031    Messages    TABLE     �  CREATE TABLE public."Messages" (
    id character varying(255) NOT NULL,
    body text NOT NULL,
    ack integer DEFAULT 0 NOT NULL,
    read boolean DEFAULT false NOT NULL,
    "mediaType" character varying(255),
    "mediaUrl" character varying(255),
    "ticketId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "fromMe" boolean DEFAULT false NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "contactId" integer,
    "quotedMsgId" character varying(255),
    "companyId" integer,
    "remoteJid" text,
    "dataJson" text,
    participant text,
    "queueId" integer,
    "isEdited" boolean DEFAULT false NOT NULL
);
    DROP TABLE public."Messages";
       public         heap r       xpectro    false            �           1259    55186    Plans    TABLE     �  CREATE TABLE public."Plans" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    users integer DEFAULT 0,
    connections integer DEFAULT 0,
    queues integer DEFAULT 0,
    value double precision DEFAULT '0'::double precision,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "useCampaigns" boolean DEFAULT true,
    "useExternalApi" boolean DEFAULT true,
    "useInternalChat" boolean DEFAULT true,
    "useSchedules" boolean DEFAULT true,
    "useKanban" boolean DEFAULT true,
    "useIntegrations" boolean DEFAULT true,
    "useOpenAi" boolean DEFAULT true
);
    DROP TABLE public."Plans";
       public         heap r       xpectro    false            �           1259    55185    Plans_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Plans_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."Plans_id_seq";
       public               xpectro    false    438                       0    0    Plans_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."Plans_id_seq" OWNED BY public."Plans".id;
          public               xpectro    false    437            �           1259    55745    Prompts    TABLE     �  CREATE TABLE public."Prompts" (
    id integer NOT NULL,
    name text NOT NULL,
    "apiKey" text NOT NULL,
    prompt text NOT NULL,
    "maxTokens" integer DEFAULT 100 NOT NULL,
    "maxMessages" integer DEFAULT 10 NOT NULL,
    temperature integer DEFAULT 1 NOT NULL,
    "promptTokens" integer DEFAULT 0 NOT NULL,
    "completionTokens" integer DEFAULT 0 NOT NULL,
    "totalTokens" integer DEFAULT 0 NOT NULL,
    voice text,
    "voiceKey" text,
    "voiceRegion" text,
    "queueId" integer NOT NULL,
    "companyId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    model character varying(255) DEFAULT 'gpt-3.5-turbo'::character varying
);
    DROP TABLE public."Prompts";
       public         heap r       xpectro    false            �           1259    55744    Prompts_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Prompts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."Prompts_id_seq";
       public               xpectro    false    492                       0    0    Prompts_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."Prompts_id_seq" OWNED BY public."Prompts".id;
          public               xpectro    false    491            �           1259    55681    QueueIntegrations    TABLE     �  CREATE TABLE public."QueueIntegrations" (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "projectName" character varying(255) NOT NULL,
    "jsonContent" text NOT NULL,
    language character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "urlN8N" character varying(255) DEFAULT true NOT NULL,
    "companyId" integer,
    "typebotExpires" integer DEFAULT 0 NOT NULL,
    "typebotSlug" character varying(255) DEFAULT ''::character varying NOT NULL,
    "typebotUnknownMessage" character varying(255) DEFAULT ''::character varying NOT NULL,
    "typebotKeywordFinish" character varying(255) DEFAULT ''::character varying NOT NULL,
    "typebotDelayMessage" integer DEFAULT 1000 NOT NULL,
    "typebotRestartMessage" character varying(255) DEFAULT ''::character varying,
    "typebotKeywordRestart" character varying(255) DEFAULT ''::character varying
);
 '   DROP TABLE public."QueueIntegrations";
       public         heap r       xpectro    false            �           1259    55680    QueueIntegrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public."QueueIntegrations_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."QueueIntegrations_id_seq";
       public               xpectro    false    486                       0    0    QueueIntegrations_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."QueueIntegrations_id_seq" OWNED BY public."QueueIntegrations".id;
          public               xpectro    false    485            �           1259    55320    QueueOptions    TABLE     #  CREATE TABLE public."QueueOptions" (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    message text,
    option text,
    "queueId" integer,
    "parentId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 "   DROP TABLE public."QueueOptions";
       public         heap r       xpectro    false            �           1259    55319    QueueOptions_id_seq    SEQUENCE     �   CREATE SEQUENCE public."QueueOptions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."QueueOptions_id_seq";
       public               xpectro    false    450                       0    0    QueueOptions_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."QueueOptions_id_seq" OWNED BY public."QueueOptions".id;
          public               xpectro    false    449            �           1259    55112    Queues    TABLE     �  CREATE TABLE public."Queues" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    color character varying(255) NOT NULL,
    "greetingMessage" text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "companyId" integer,
    schedules jsonb DEFAULT '[]'::jsonb,
    "outOfHoursMessage" text,
    "orderQueue" integer,
    "integrationId" integer,
    "promptId" integer
);
    DROP TABLE public."Queues";
       public         heap r       xpectro    false            �           1259    55111 
   Queues_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Queues_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public."Queues_id_seq";
       public               xpectro    false    432                       0    0 
   Queues_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."Queues_id_seq" OWNED BY public."Queues".id;
          public               xpectro    false    431            �           1259    55228 
   QuickMessages    TABLE     �  CREATE TABLE public."QuickMessages" (
    id integer NOT NULL,
    shortcode character varying(255) NOT NULL,
    message text,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" integer,
    "mediaPath" character varying(255) DEFAULT NULL::character varying,
    "mediaName" character varying(255) DEFAULT NULL::character varying
);
 #   DROP TABLE public."QuickMessages";
       public         heap r       xpectro    false            �           1259    55227    QuickMessages_id_seq    SEQUENCE     �   CREATE SEQUENCE public."QuickMessages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."QuickMessages_id_seq";
       public               xpectro    false    442                       0    0    QuickMessages_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."QuickMessages_id_seq" OWNED BY public."QuickMessages".id;
          public               xpectro    false    441            �           1259    55345 	   Schedules    TABLE       CREATE TABLE public."Schedules" (
    id integer NOT NULL,
    body text NOT NULL,
    "sendAt" timestamp with time zone,
    "sentAt" timestamp with time zone,
    "contactId" integer,
    "ticketId" integer,
    "userId" integer,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    status character varying(255),
    "mediaName" character varying(255) DEFAULT NULL::character varying,
    "mediaPath" character varying(255) DEFAULT NULL::character varying
);
    DROP TABLE public."Schedules";
       public         heap r       xpectro    false            �           1259    55344    Schedules_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Schedules_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."Schedules_id_seq";
       public               xpectro    false    452                       0    0    Schedules_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."Schedules_id_seq" OWNED BY public."Schedules".id;
          public               xpectro    false    451            �           1259    54975 
   SequelizeMeta    TABLE     R   CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);
 #   DROP TABLE public."SequelizeMeta";
       public         heap r       xpectro    false            �           1259    55076    Settings    TABLE     �   CREATE TABLE public."Settings" (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "companyId" integer,
    id integer NOT NULL
);
    DROP TABLE public."Settings";
       public         heap r       xpectro    false            �           1259    55496    Settings_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Settings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."Settings_id_seq";
       public               xpectro    false    430                       0    0    Settings_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."Settings_id_seq" OWNED BY public."Settings".id;
          public               xpectro    false    466            �           1259    55611 
   Subscriptions    TABLE     �  CREATE TABLE public."Subscriptions" (
    id integer NOT NULL,
    "isActive" boolean DEFAULT false,
    "expiresAt" timestamp with time zone NOT NULL,
    "userPriceCents" integer,
    "whatsPriceCents" integer,
    "lastInvoiceUrl" character varying(255),
    "lastPlanChange" timestamp with time zone,
    "companyId" integer,
    "providerSubscriptionId" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 #   DROP TABLE public."Subscriptions";
       public         heap r       xpectro    false            �           1259    55610    Subscriptions_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Subscriptions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."Subscriptions_id_seq";
       public               xpectro    false    478            	           0    0    Subscriptions_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."Subscriptions_id_seq" OWNED BY public."Subscriptions".id;
          public               xpectro    false    477            �           1259    55379    Tags    TABLE        CREATE TABLE public."Tags" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    color character varying(255),
    "companyId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    kanban integer
);
    DROP TABLE public."Tags";
       public         heap r       xpectro    false            �           1259    55378    Tags_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Tags_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public."Tags_id_seq";
       public               xpectro    false    454            
           0    0    Tags_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public."Tags_id_seq" OWNED BY public."Tags".id;
          public               xpectro    false    453            �           1259    55206    TicketNotes    TABLE       CREATE TABLE public."TicketNotes" (
    id integer NOT NULL,
    note character varying(255) NOT NULL,
    "userId" integer,
    "contactId" integer NOT NULL,
    "ticketId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 !   DROP TABLE public."TicketNotes";
       public         heap r       xpectro    false            �           1259    55205    TicketNotes_id_seq    SEQUENCE     �   CREATE SEQUENCE public."TicketNotes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."TicketNotes_id_seq";
       public               xpectro    false    440                       0    0    TicketNotes_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."TicketNotes_id_seq" OWNED BY public."TicketNotes".id;
          public               xpectro    false    439            �           1259    55392 
   TicketTags    TABLE     �   CREATE TABLE public."TicketTags" (
    "ticketId" integer NOT NULL,
    "tagId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
     DROP TABLE public."TicketTags";
       public         heap r       xpectro    false            �           1259    55254 
   TicketTraking    TABLE     �  CREATE TABLE public."TicketTraking" (
    id integer NOT NULL,
    "ticketId" integer,
    "companyId" integer,
    "whatsappId" integer,
    "userId" integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "queuedAt" timestamp with time zone,
    "startedAt" timestamp with time zone,
    "finishedAt" timestamp with time zone,
    "ratingAt" timestamp with time zone,
    rated boolean DEFAULT false,
    "chatbotAt" timestamp with time zone
);
 #   DROP TABLE public."TicketTraking";
       public         heap r       xpectro    false            �           1259    55253    TicketTraking_id_seq    SEQUENCE     �   CREATE SEQUENCE public."TicketTraking_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."TicketTraking_id_seq";
       public               xpectro    false    446                       0    0    TicketTraking_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."TicketTraking_id_seq" OWNED BY public."TicketTraking".id;
          public               xpectro    false    445            �           1259    55012    Tickets    TABLE     �  CREATE TABLE public."Tickets" (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    "lastMessage" text DEFAULT ''::text,
    "contactId" integer,
    "userId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "whatsappId" integer,
    "isGroup" boolean DEFAULT false NOT NULL,
    "unreadMessages" integer,
    "queueId" integer,
    "companyId" integer,
    uuid uuid DEFAULT public.uuid_generate_v4(),
    "queueOptionId" integer,
    chatbot boolean DEFAULT false,
    "amountUsedBotQueues" integer,
    "fromMe" boolean DEFAULT false NOT NULL,
    "useIntegration" boolean DEFAULT false,
    "integrationId" integer,
    "typebotSessionId" character varying(255) DEFAULT NULL::character varying,
    "typebotStatus" boolean DEFAULT false NOT NULL,
    "promptId" character varying(255) DEFAULT NULL::character varying
);
    DROP TABLE public."Tickets";
       public         heap r       xpectro    false    2            �           1259    55011    Tickets_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Tickets_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."Tickets_id_seq";
       public               xpectro    false    424            
           0    0    Tickets_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."Tickets_id_seq" OWNED BY public."Tickets".id;
          public               xpectro    false    423            �           1259    55134 
   UserQueues    TABLE     �   CREATE TABLE public."UserQueues" (
    "userId" integer NOT NULL,
    "queueId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
     DROP TABLE public."UserQueues";
       public         heap r       xpectro    false            �           1259    55282    UserRatings    TABLE     �   CREATE TABLE public."UserRatings" (
    id integer NOT NULL,
    "ticketId" integer,
    "companyId" integer,
    "userId" integer,
    rate integer DEFAULT 0,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);
 !   DROP TABLE public."UserRatings";
       public         heap r       xpectro    false            �           1259    55281    UserRatings_id_seq    SEQUENCE     �   CREATE SEQUENCE public."UserRatings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."UserRatings_id_seq";
       public               xpectro    false    448                       0    0    UserRatings_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."UserRatings_id_seq" OWNED BY public."UserRatings".id;
          public               xpectro    false    447            �           1259    54992    Users    TABLE     �  CREATE TABLE public."Users" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    "passwordHash" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    profile character varying(255) DEFAULT 'admin'::character varying NOT NULL,
    "tokenVersion" integer DEFAULT 0 NOT NULL,
    "companyId" integer,
    super boolean DEFAULT false,
    online boolean DEFAULT false,
    "allTicket" character varying(255) DEFAULT 'desabled'::character varying NOT NULL,
    "whatsappId" integer,
    "resetPassword" character varying(255)
);
    DROP TABLE public."Users";
       public         heap r       xpectro    false            �           1259    54991    Users_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."Users_id_seq";
       public               xpectro    false    420                       0    0    Users_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."Users_id_seq" OWNED BY public."Users".id;
          public               xpectro    false    419            �           1259    55129    WhatsappQueues    TABLE     �   CREATE TABLE public."WhatsappQueues" (
    "whatsappId" integer NOT NULL,
    "queueId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 $   DROP TABLE public."WhatsappQueues";
       public         heap r       xpectro    false            �           1259    55051 	   Whatsapps    TABLE     �  CREATE TABLE public."Whatsapps" (
    id integer NOT NULL,
    session text,
    qrcode text,
    status character varying(255),
    battery character varying(255),
    plugged boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    "isDefault" boolean DEFAULT false NOT NULL,
    retries integer DEFAULT 0 NOT NULL,
    "greetingMessage" text,
    "companyId" integer,
    "complationMessage" text,
    "outOfHoursMessage" text,
    "ratingMessage" text,
    token text,
    "farewellMessage" text,
    provider text DEFAULT 'stable'::text,
    "sendIdQueue" integer,
    "promptId" integer,
    "integrationId" integer,
    "expiresTicket" integer DEFAULT 0,
    "expiresInactiveMessage" character varying(255) DEFAULT ''::character varying,
    "maxUseBotQueues" integer DEFAULT 3,
    "timeUseBotQueues" integer DEFAULT 0,
    "transferQueueId" integer,
    "timeToTransfer" integer
);
    DROP TABLE public."Whatsapps";
       public         heap r       xpectro    false            �           1259    55050    Whatsapps_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Whatsapps_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."Whatsapps_id_seq";
       public               xpectro    false    427                       0    0    Whatsapps_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."Whatsapps_id_seq" OWNED BY public."Whatsapps".id;
          public               xpectro    false    426            :           2604    55535    Announcements id    DEFAULT     x   ALTER TABLE ONLY public."Announcements" ALTER COLUMN id SET DEFAULT nextval('public."Announcements_id_seq"'::regclass);
 A   ALTER TABLE public."Announcements" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    470    469    470            (           2604    55410 
   Baileys id    DEFAULT     l   ALTER TABLE ONLY public."Baileys" ALTER COLUMN id SET DEFAULT nextval('public."Baileys_id_seq"'::regclass);
 ;   ALTER TABLE public."Baileys" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    457    456    457            E           2604    55645    BaileysChats id    DEFAULT     v   ALTER TABLE ONLY public."BaileysChats" ALTER COLUMN id SET DEFAULT nextval('public."BaileysChats_id_seq"'::regclass);
 @   ALTER TABLE public."BaileysChats" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    481    482    482            G           2604    55660    BaileysMessages id    DEFAULT     |   ALTER TABLE ONLY public."BaileysMessages" ALTER COLUMN id SET DEFAULT nextval('public."BaileysMessages_id_seq"'::regclass);
 C   ALTER TABLE public."BaileysMessages" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    484    483    484            8           2604    55486    CampaignSettings id    DEFAULT     ~   ALTER TABLE ONLY public."CampaignSettings" ALTER COLUMN id SET DEFAULT nextval('public."CampaignSettings_id_seq"'::regclass);
 D   ALTER TABLE public."CampaignSettings" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    465    464    465            9           2604    55507    CampaignShipping id    DEFAULT     ~   ALTER TABLE ONLY public."CampaignShipping" ALTER COLUMN id SET DEFAULT nextval('public."CampaignShipping_id_seq"'::regclass);
 D   ALTER TABLE public."CampaignShipping" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    467    468    468            ,           2604    55451    Campaigns id    DEFAULT     p   ALTER TABLE ONLY public."Campaigns" ALTER COLUMN id SET DEFAULT nextval('public."Campaigns_id_seq"'::regclass);
 =   ALTER TABLE public."Campaigns" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    462    463    463            @           2604    55588    ChatMessages id    DEFAULT     v   ALTER TABLE ONLY public."ChatMessages" ALTER COLUMN id SET DEFAULT nextval('public."ChatMessages_id_seq"'::regclass);
 @   ALTER TABLE public."ChatMessages" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    476    475    476            >           2604    55570    ChatUsers id    DEFAULT     p   ALTER TABLE ONLY public."ChatUsers" ALTER COLUMN id SET DEFAULT nextval('public."ChatUsers_id_seq"'::regclass);
 =   ALTER TABLE public."ChatUsers" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    473    474    474            ;           2604    55549    Chats id    DEFAULT     h   ALTER TABLE ONLY public."Chats" ALTER COLUMN id SET DEFAULT nextval('public."Chats_id_seq"'::regclass);
 9   ALTER TABLE public."Chats" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    472    471    472            
           2604    55143    Companies id    DEFAULT     p   ALTER TABLE ONLY public."Companies" ALTER COLUMN id SET DEFAULT nextval('public."Companies_id_seq"'::regclass);
 =   ALTER TABLE public."Companies" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    436    435    436                       2604    55063    ContactCustomFields id    DEFAULT     �   ALTER TABLE ONLY public."ContactCustomFields" ALTER COLUMN id SET DEFAULT nextval('public."ContactCustomFields_id_seq"'::regclass);
 G   ALTER TABLE public."ContactCustomFields" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    428    429    429            *           2604    55431    ContactListItems id    DEFAULT     ~   ALTER TABLE ONLY public."ContactListItems" ALTER COLUMN id SET DEFAULT nextval('public."ContactListItems_id_seq"'::regclass);
 D   ALTER TABLE public."ContactListItems" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    460    461    461            )           2604    55419    ContactLists id    DEFAULT     v   ALTER TABLE ONLY public."ContactLists" ALTER COLUMN id SET DEFAULT nextval('public."ContactLists_id_seq"'::regclass);
 @   ALTER TABLE public."ContactLists" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    459    458    459            �
           2604    55006    Contacts id    DEFAULT     n   ALTER TABLE ONLY public."Contacts" ALTER COLUMN id SET DEFAULT nextval('public."Contacts_id_seq"'::regclass);
 <   ALTER TABLE public."Contacts" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    422    421    422            Q           2604    55708    Files id    DEFAULT     h   ALTER TABLE ONLY public."Files" ALTER COLUMN id SET DEFAULT nextval('public."Files_id_seq"'::regclass);
 9   ALTER TABLE public."Files" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    488    487    488            R           2604    55722    FilesOptions id    DEFAULT     v   ALTER TABLE ONLY public."FilesOptions" ALTER COLUMN id SET DEFAULT nextval('public."FilesOptions_id_seq"'::regclass);
 @   ALTER TABLE public."FilesOptions" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    490    489    490                       2604    55246    Helps id    DEFAULT     h   ALTER TABLE ONLY public."Helps" ALTER COLUMN id SET DEFAULT nextval('public."Helps_id_seq"'::regclass);
 9   ALTER TABLE public."Helps" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    444    443    444            D           2604    55629    Invoices id    DEFAULT     n   ALTER TABLE ONLY public."Invoices" ALTER COLUMN id SET DEFAULT nextval('public."Invoices_id_seq"'::regclass);
 <   ALTER TABLE public."Invoices" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    479    480    480                       2604    55189    Plans id    DEFAULT     h   ALTER TABLE ONLY public."Plans" ALTER COLUMN id SET DEFAULT nextval('public."Plans_id_seq"'::regclass);
 9   ALTER TABLE public."Plans" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    438    437    438            T           2604    55748 
   Prompts id    DEFAULT     l   ALTER TABLE ONLY public."Prompts" ALTER COLUMN id SET DEFAULT nextval('public."Prompts_id_seq"'::regclass);
 ;   ALTER TABLE public."Prompts" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    492    491    492            H           2604    55684    QueueIntegrations id    DEFAULT     �   ALTER TABLE ONLY public."QueueIntegrations" ALTER COLUMN id SET DEFAULT nextval('public."QueueIntegrations_id_seq"'::regclass);
 E   ALTER TABLE public."QueueIntegrations" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    486    485    486            #           2604    55323    QueueOptions id    DEFAULT     v   ALTER TABLE ONLY public."QueueOptions" ALTER COLUMN id SET DEFAULT nextval('public."QueueOptions_id_seq"'::regclass);
 @   ALTER TABLE public."QueueOptions" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    449    450    450                       2604    55115 	   Queues id    DEFAULT     j   ALTER TABLE ONLY public."Queues" ALTER COLUMN id SET DEFAULT nextval('public."Queues_id_seq"'::regclass);
 :   ALTER TABLE public."Queues" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    431    432    432                       2604    55231    QuickMessages id    DEFAULT     x   ALTER TABLE ONLY public."QuickMessages" ALTER COLUMN id SET DEFAULT nextval('public."QuickMessages_id_seq"'::regclass);
 A   ALTER TABLE public."QuickMessages" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    442    441    442            $           2604    55348    Schedules id    DEFAULT     p   ALTER TABLE ONLY public."Schedules" ALTER COLUMN id SET DEFAULT nextval('public."Schedules_id_seq"'::regclass);
 =   ALTER TABLE public."Schedules" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    452    451    452                       2604    55497    Settings id    DEFAULT     n   ALTER TABLE ONLY public."Settings" ALTER COLUMN id SET DEFAULT nextval('public."Settings_id_seq"'::regclass);
 <   ALTER TABLE public."Settings" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    466    430            B           2604    55614    Subscriptions id    DEFAULT     x   ALTER TABLE ONLY public."Subscriptions" ALTER COLUMN id SET DEFAULT nextval('public."Subscriptions_id_seq"'::regclass);
 A   ALTER TABLE public."Subscriptions" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    478    477    478            '           2604    55382    Tags id    DEFAULT     f   ALTER TABLE ONLY public."Tags" ALTER COLUMN id SET DEFAULT nextval('public."Tags_id_seq"'::regclass);
 8   ALTER TABLE public."Tags" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    454    453    454                       2604    55209    TicketNotes id    DEFAULT     t   ALTER TABLE ONLY public."TicketNotes" ALTER COLUMN id SET DEFAULT nextval('public."TicketNotes_id_seq"'::regclass);
 ?   ALTER TABLE public."TicketNotes" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    440    439    440                       2604    55257    TicketTraking id    DEFAULT     x   ALTER TABLE ONLY public."TicketTraking" ALTER COLUMN id SET DEFAULT nextval('public."TicketTraking_id_seq"'::regclass);
 A   ALTER TABLE public."TicketTraking" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    446    445    446            �
           2604    55015 
   Tickets id    DEFAULT     l   ALTER TABLE ONLY public."Tickets" ALTER COLUMN id SET DEFAULT nextval('public."Tickets_id_seq"'::regclass);
 ;   ALTER TABLE public."Tickets" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    423    424    424            !           2604    55285    UserRatings id    DEFAULT     t   ALTER TABLE ONLY public."UserRatings" ALTER COLUMN id SET DEFAULT nextval('public."UserRatings_id_seq"'::regclass);
 ?   ALTER TABLE public."UserRatings" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    448    447    448            �
           2604    54995    Users id    DEFAULT     h   ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);
 9   ALTER TABLE public."Users" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    420    419    420            �
           2604    55054    Whatsapps id    DEFAULT     p   ALTER TABLE ONLY public."Whatsapps" ALTER COLUMN id SET DEFAULT nextval('public."Whatsapps_id_seq"'::regclass);
 =   ALTER TABLE public."Whatsapps" ALTER COLUMN id DROP DEFAULT;
       public               xpectro    false    427    426    427            �          0    55532 
   Announcements 
   TABLE DATA           �   COPY public."Announcements" (id, priority, title, text, "mediaPath", "mediaName", "companyId", status, "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    470   =�      �          0    55407    Baileys 
   TABLE DATA           `   COPY public."Baileys" (id, "whatsappId", contacts, chats, "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    457   Z�      �          0    55642    BaileysChats 
   TABLE DATA           �   COPY public."BaileysChats" (id, "whatsappId", jid, "conversationTimestamp", "unreadCount", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    482   w�      �          0    55657    BaileysMessages 
   TABLE DATA           w   COPY public."BaileysMessages" (id, "whatsappId", "baileysChatId", "jsonMessage", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    484   ��      �          0    55483    CampaignSettings 
   TABLE DATA           c   COPY public."CampaignSettings" (id, key, value, "companyId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    465   ��      �          0    55504    CampaignShipping 
   TABLE DATA           �   COPY public."CampaignShipping" (id, "jobId", number, message, "confirmationMessage", confirmation, "contactId", "campaignId", "confirmationRequestedAt", "confirmedAt", "deliveredAt", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    468   ��      �          0    55448 	   Campaigns 
   TABLE DATA           �  COPY public."Campaigns" (id, name, message1, message2, message3, message4, message5, "confirmationMessage1", "confirmationMessage2", "confirmationMessage3", "confirmationMessage4", "confirmationMessage5", status, confirmation, "mediaPath", "mediaName", "companyId", "contactListId", "whatsappId", "scheduledAt", "completedAt", "createdAt", "updatedAt", "fileListId", "tagId") FROM stdin;
    public               xpectro    false    463   ��      �          0    55585    ChatMessages 
   TABLE DATA              COPY public."ChatMessages" (id, "chatId", "senderId", message, "mediaPath", "mediaName", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    476   �      �          0    55567 	   ChatUsers 
   TABLE DATA           `   COPY public."ChatUsers" (id, "chatId", "userId", unreads, "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    474   %�      �          0    55546    Chats 
   TABLE DATA           s   COPY public."Chats" (id, title, uuid, "ownerId", "lastMessage", "companyId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    472   B�      �          0    55140 	   Companies 
   TABLE DATA           �   COPY public."Companies" (id, name, phone, email, "createdAt", "updatedAt", "planId", status, schedules, "dueDate", recurrence) FROM stdin;
    public               xpectro    false    436   _�      �          0    55060    ContactCustomFields 
   TABLE DATA           g   COPY public."ContactCustomFields" (id, name, value, "contactId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    429   o�      �          0    55428    ContactListItems 
   TABLE DATA           �   COPY public."ContactListItems" (id, name, number, email, "contactListId", "isWhatsappValid", "companyId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    461   ��      �          0    55416    ContactLists 
   TABLE DATA           Y   COPY public."ContactLists" (id, name, "companyId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    459   ��      �          0    55003    Contacts 
   TABLE DATA           �   COPY public."Contacts" (id, name, number, "profilePicUrl", "createdAt", "updatedAt", email, "isGroup", "companyId", "whatsappId") FROM stdin;
    public               xpectro    false    422   ��      �          0    55705    Files 
   TABLE DATA           [   COPY public."Files" (id, "companyId", name, message, "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    488   ��      �          0    55719    FilesOptions 
   TABLE DATA           i   COPY public."FilesOptions" (id, name, path, "fileId", "createdAt", "updatedAt", "mediaType") FROM stdin;
    public               xpectro    false    490    �      �          0    55243    Helps 
   TABLE DATA           `   COPY public."Helps" (id, title, description, video, link, "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    444   �      �          0    55626    Invoices 
   TABLE DATA           q   COPY public."Invoices" (id, detail, status, value, "createdAt", "updatedAt", "dueDate", "companyId") FROM stdin;
    public               xpectro    false    480   :�      �          0    55031    Messages 
   TABLE DATA           �   COPY public."Messages" (id, body, ack, read, "mediaType", "mediaUrl", "ticketId", "createdAt", "updatedAt", "fromMe", "isDeleted", "contactId", "quotedMsgId", "companyId", "remoteJid", "dataJson", participant, "queueId", "isEdited") FROM stdin;
    public               xpectro    false    425   ��      �          0    55186    Plans 
   TABLE DATA           �   COPY public."Plans" (id, name, users, connections, queues, value, "createdAt", "updatedAt", "useCampaigns", "useExternalApi", "useInternalChat", "useSchedules", "useKanban", "useIntegrations", "useOpenAi") FROM stdin;
    public               xpectro    false    438   ��      �          0    55745    Prompts 
   TABLE DATA           �   COPY public."Prompts" (id, name, "apiKey", prompt, "maxTokens", "maxMessages", temperature, "promptTokens", "completionTokens", "totalTokens", voice, "voiceKey", "voiceRegion", "queueId", "companyId", "createdAt", "updatedAt", model) FROM stdin;
    public               xpectro    false    492   8�      �          0    55681    QueueIntegrations 
   TABLE DATA           1  COPY public."QueueIntegrations" (id, type, name, "projectName", "jsonContent", language, "createdAt", "updatedAt", "urlN8N", "companyId", "typebotExpires", "typebotSlug", "typebotUnknownMessage", "typebotKeywordFinish", "typebotDelayMessage", "typebotRestartMessage", "typebotKeywordRestart") FROM stdin;
    public               xpectro    false    486   U�      �          0    55320    QueueOptions 
   TABLE DATA           u   COPY public."QueueOptions" (id, title, message, option, "queueId", "parentId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    450   r�      �          0    55112    Queues 
   TABLE DATA           �   COPY public."Queues" (id, name, color, "greetingMessage", "createdAt", "updatedAt", "companyId", schedules, "outOfHoursMessage", "orderQueue", "integrationId", "promptId") FROM stdin;
    public               xpectro    false    432   ��      �          0    55228 
   QuickMessages 
   TABLE DATA           �   COPY public."QuickMessages" (id, shortcode, message, "companyId", "createdAt", "updatedAt", "userId", "mediaPath", "mediaName") FROM stdin;
    public               xpectro    false    442   ��      �          0    55345 	   Schedules 
   TABLE DATA           �   COPY public."Schedules" (id, body, "sendAt", "sentAt", "contactId", "ticketId", "userId", "companyId", "createdAt", "updatedAt", status, "mediaName", "mediaPath") FROM stdin;
    public               xpectro    false    452   ��      �          0    54975 
   SequelizeMeta 
   TABLE DATA           /   COPY public."SequelizeMeta" (name) FROM stdin;
    public               xpectro    false    418   ��      �          0    55076    Settings 
   TABLE DATA           [   COPY public."Settings" (key, value, "createdAt", "updatedAt", "companyId", id) FROM stdin;
    public               xpectro    false    430   ��      �          0    55611 
   Subscriptions 
   TABLE DATA           �   COPY public."Subscriptions" (id, "isActive", "expiresAt", "userPriceCents", "whatsPriceCents", "lastInvoiceUrl", "lastPlanChange", "companyId", "providerSubscriptionId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    478   ��      �          0    55379    Tags 
   TABLE DATA           `   COPY public."Tags" (id, name, color, "companyId", "createdAt", "updatedAt", kanban) FROM stdin;
    public               xpectro    false    454   �      �          0    55206    TicketNotes 
   TABLE DATA           n   COPY public."TicketNotes" (id, note, "userId", "contactId", "ticketId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    440   0�      �          0    55392 
   TicketTags 
   TABLE DATA           U   COPY public."TicketTags" ("ticketId", "tagId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    455   M�      �          0    55254 
   TicketTraking 
   TABLE DATA           �   COPY public."TicketTraking" (id, "ticketId", "companyId", "whatsappId", "userId", "createdAt", "updatedAt", "queuedAt", "startedAt", "finishedAt", "ratingAt", rated, "chatbotAt") FROM stdin;
    public               xpectro    false    446   j�      �          0    55012    Tickets 
   TABLE DATA           G  COPY public."Tickets" (id, status, "lastMessage", "contactId", "userId", "createdAt", "updatedAt", "whatsappId", "isGroup", "unreadMessages", "queueId", "companyId", uuid, "queueOptionId", chatbot, "amountUsedBotQueues", "fromMe", "useIntegration", "integrationId", "typebotSessionId", "typebotStatus", "promptId") FROM stdin;
    public               xpectro    false    424   N      �          0    55134 
   UserQueues 
   TABLE DATA           U   COPY public."UserQueues" ("userId", "queueId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    434   k      �          0    55282    UserRatings 
   TABLE DATA           n   COPY public."UserRatings" (id, "ticketId", "companyId", "userId", rate, "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    448   �      �          0    54992    Users 
   TABLE DATA           �   COPY public."Users" (id, name, email, "passwordHash", "createdAt", "updatedAt", profile, "tokenVersion", "companyId", super, online, "allTicket", "whatsappId", "resetPassword") FROM stdin;
    public               xpectro    false    420   �      �          0    55129    WhatsappQueues 
   TABLE DATA           ]   COPY public."WhatsappQueues" ("whatsappId", "queueId", "createdAt", "updatedAt") FROM stdin;
    public               xpectro    false    433   :      �          0    55051 	   Whatsapps 
   TABLE DATA           �  COPY public."Whatsapps" (id, session, qrcode, status, battery, plugged, "createdAt", "updatedAt", name, "isDefault", retries, "greetingMessage", "companyId", "complationMessage", "outOfHoursMessage", "ratingMessage", token, "farewellMessage", provider, "sendIdQueue", "promptId", "integrationId", "expiresTicket", "expiresInactiveMessage", "maxUseBotQueues", "timeUseBotQueues", "transferQueueId", "timeToTransfer") FROM stdin;
    public               xpectro    false    427   W                 0    0    Announcements_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."Announcements_id_seq"', 1, false);
          public               xpectro    false    469                       0    0    BaileysChats_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."BaileysChats_id_seq"', 1, false);
          public               xpectro    false    481                       0    0    BaileysMessages_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."BaileysMessages_id_seq"', 1, false);
          public               xpectro    false    483                       0    0    Baileys_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public."Baileys_id_seq"', 3, true);
          public               xpectro    false    456                       0    0    CampaignSettings_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."CampaignSettings_id_seq"', 1, false);
          public               xpectro    false    464                       0    0    CampaignShipping_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."CampaignShipping_id_seq"', 1, true);
          public               xpectro    false    467                       0    0    Campaigns_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Campaigns_id_seq"', 2, true);
          public               xpectro    false    462                       0    0    ChatMessages_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."ChatMessages_id_seq"', 2, true);
          public               xpectro    false    475                       0    0    ChatUsers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."ChatUsers_id_seq"', 2, true);
          public               xpectro    false    473                       0    0    Chats_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public."Chats_id_seq"', 1, true);
          public               xpectro    false    471                       0    0    Companies_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Companies_id_seq"', 3, true);
          public               xpectro    false    435                       0    0    ContactCustomFields_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."ContactCustomFields_id_seq"', 1, false);
          public               xpectro    false    428                       0    0    ContactListItems_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."ContactListItems_id_seq"', 1, true);
          public               xpectro    false    460                       0    0    ContactLists_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."ContactLists_id_seq"', 1, true);
          public               xpectro    false    458                       0    0    Contacts_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."Contacts_id_seq"', 288, true);
          public               xpectro    false    421                        0    0    FilesOptions_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."FilesOptions_id_seq"', 1, false);
          public               xpectro    false    489            !           0    0    Files_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public."Files_id_seq"', 1, false);
          public               xpectro    false    487            "           0    0    Helps_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public."Helps_id_seq"', 1, false);
          public               xpectro    false    443            #           0    0    Invoices_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."Invoices_id_seq"', 2, true);
          public               xpectro    false    479            $           0    0    Plans_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public."Plans_id_seq"', 1, false);
          public               xpectro    false    437            %           0    0    Prompts_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."Prompts_id_seq"', 1, false);
          public               xpectro    false    491            &           0    0    QueueIntegrations_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."QueueIntegrations_id_seq"', 1, false);
          public               xpectro    false    485            '           0    0    QueueOptions_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."QueueOptions_id_seq"', 1, false);
          public               xpectro    false    449            (           0    0 
   Queues_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public."Queues_id_seq"', 1, false);
          public               xpectro    false    431            )           0    0    QuickMessages_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."QuickMessages_id_seq"', 1, false);
          public               xpectro    false    441            *           0    0    Schedules_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Schedules_id_seq"', 1, true);
          public               xpectro    false    451            +           0    0    Settings_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Settings_id_seq"', 1, false);
          public               xpectro    false    466            ,           0    0    Subscriptions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."Subscriptions_id_seq"', 1, false);
          public               xpectro    false    477            -           0    0    Tags_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public."Tags_id_seq"', 2, true);
          public               xpectro    false    453            .           0    0    TicketNotes_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."TicketNotes_id_seq"', 1, false);
          public               xpectro    false    439            /           0    0    TicketTraking_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."TicketTraking_id_seq"', 102, true);
          public               xpectro    false    445            0           0    0    Tickets_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."Tickets_id_seq"', 86, true);
          public               xpectro    false    423            1           0    0    UserRatings_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."UserRatings_id_seq"', 1, false);
          public               xpectro    false    447            2           0    0    Users_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public."Users_id_seq"', 3, true);
          public               xpectro    false    419            3           0    0    Whatsapps_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Whatsapps_id_seq"', 8, true);
          public               xpectro    false    426            �           2606    55539     Announcements Announcements_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."Announcements"
    ADD CONSTRAINT "Announcements_pkey" PRIMARY KEY (id);
 N   ALTER TABLE ONLY public."Announcements" DROP CONSTRAINT "Announcements_pkey";
       public                 xpectro    false    470            �           2606    55650    BaileysChats BaileysChats_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."BaileysChats"
    ADD CONSTRAINT "BaileysChats_pkey" PRIMARY KEY (id);
 L   ALTER TABLE ONLY public."BaileysChats" DROP CONSTRAINT "BaileysChats_pkey";
       public                 xpectro    false    482            �           2606    55664 $   BaileysMessages BaileysMessages_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."BaileysMessages"
    ADD CONSTRAINT "BaileysMessages_pkey" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public."BaileysMessages" DROP CONSTRAINT "BaileysMessages_pkey";
       public                 xpectro    false    484            �           2606    55414    Baileys Baileys_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."Baileys"
    ADD CONSTRAINT "Baileys_pkey" PRIMARY KEY (id, "whatsappId");
 B   ALTER TABLE ONLY public."Baileys" DROP CONSTRAINT "Baileys_pkey";
       public                 xpectro    false    457    457            �           2606    55490 &   CampaignSettings CampaignSettings_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CampaignSettings"
    ADD CONSTRAINT "CampaignSettings_pkey" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public."CampaignSettings" DROP CONSTRAINT "CampaignSettings_pkey";
       public                 xpectro    false    465            �           2606    55511 &   CampaignShipping CampaignShipping_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."CampaignShipping"
    ADD CONSTRAINT "CampaignShipping_pkey" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public."CampaignShipping" DROP CONSTRAINT "CampaignShipping_pkey";
       public                 xpectro    false    468            �           2606    55466    Campaigns Campaigns_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_pkey" PRIMARY KEY (id);
 F   ALTER TABLE ONLY public."Campaigns" DROP CONSTRAINT "Campaigns_pkey";
       public                 xpectro    false    463            �           2606    55593    ChatMessages ChatMessages_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."ChatMessages"
    ADD CONSTRAINT "ChatMessages_pkey" PRIMARY KEY (id);
 L   ALTER TABLE ONLY public."ChatMessages" DROP CONSTRAINT "ChatMessages_pkey";
       public                 xpectro    false    476            �           2606    55573    ChatUsers ChatUsers_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."ChatUsers"
    ADD CONSTRAINT "ChatUsers_pkey" PRIMARY KEY (id);
 F   ALTER TABLE ONLY public."ChatUsers" DROP CONSTRAINT "ChatUsers_pkey";
       public                 xpectro    false    474            �           2606    55555    Chats Chats_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_pkey" PRIMARY KEY (id);
 >   ALTER TABLE ONLY public."Chats" DROP CONSTRAINT "Chats_pkey";
       public                 xpectro    false    472                       2606    55149    Companies Companies_name_key 
   CONSTRAINT     [   ALTER TABLE ONLY public."Companies"
    ADD CONSTRAINT "Companies_name_key" UNIQUE (name);
 J   ALTER TABLE ONLY public."Companies" DROP CONSTRAINT "Companies_name_key";
       public                 xpectro    false    436            �           2606    55147    Companies Companies_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Companies"
    ADD CONSTRAINT "Companies_pkey" PRIMARY KEY (id);
 F   ALTER TABLE ONLY public."Companies" DROP CONSTRAINT "Companies_pkey";
       public                 xpectro    false    436            s           2606    55067 ,   ContactCustomFields ContactCustomFields_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."ContactCustomFields"
    ADD CONSTRAINT "ContactCustomFields_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."ContactCustomFields" DROP CONSTRAINT "ContactCustomFields_pkey";
       public                 xpectro    false    429            �           2606    55436 &   ContactListItems ContactListItems_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."ContactListItems"
    ADD CONSTRAINT "ContactListItems_pkey" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public."ContactListItems" DROP CONSTRAINT "ContactListItems_pkey";
       public                 xpectro    false    461            �           2606    55421    ContactLists ContactLists_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."ContactLists"
    ADD CONSTRAINT "ContactLists_pkey" PRIMARY KEY (id);
 L   ALTER TABLE ONLY public."ContactLists" DROP CONSTRAINT "ContactLists_pkey";
       public                 xpectro    false    459            c           2606    55010    Contacts Contacts_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."Contacts"
    ADD CONSTRAINT "Contacts_pkey" PRIMARY KEY (id);
 D   ALTER TABLE ONLY public."Contacts" DROP CONSTRAINT "Contacts_pkey";
       public                 xpectro    false    422            �           2606    55726    FilesOptions FilesOptions_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."FilesOptions"
    ADD CONSTRAINT "FilesOptions_pkey" PRIMARY KEY (id);
 L   ALTER TABLE ONLY public."FilesOptions" DROP CONSTRAINT "FilesOptions_pkey";
       public                 xpectro    false    490            �           2606    55712    Files Files_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "Files_pkey" PRIMARY KEY (id);
 >   ALTER TABLE ONLY public."Files" DROP CONSTRAINT "Files_pkey";
       public                 xpectro    false    488            �           2606    55250    Helps Helps_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."Helps"
    ADD CONSTRAINT "Helps_pkey" PRIMARY KEY (id);
 >   ALTER TABLE ONLY public."Helps" DROP CONSTRAINT "Helps_pkey";
       public                 xpectro    false    444            �           2606    55633    Invoices Invoices_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."Invoices"
    ADD CONSTRAINT "Invoices_pkey" PRIMARY KEY (id);
 D   ALTER TABLE ONLY public."Invoices" DROP CONSTRAINT "Invoices_pkey";
       public                 xpectro    false    480            l           2606    55039    Messages Messages_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_pkey" PRIMARY KEY (id);
 D   ALTER TABLE ONLY public."Messages" DROP CONSTRAINT "Messages_pkey";
       public                 xpectro    false    425            �           2606    55197    Plans Plans_name_key 
   CONSTRAINT     S   ALTER TABLE ONLY public."Plans"
    ADD CONSTRAINT "Plans_name_key" UNIQUE (name);
 B   ALTER TABLE ONLY public."Plans" DROP CONSTRAINT "Plans_name_key";
       public                 xpectro    false    438            �           2606    55195    Plans Plans_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."Plans"
    ADD CONSTRAINT "Plans_pkey" PRIMARY KEY (id);
 >   ALTER TABLE ONLY public."Plans" DROP CONSTRAINT "Plans_pkey";
       public                 xpectro    false    438            �           2606    55758    Prompts Prompts_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public."Prompts"
    ADD CONSTRAINT "Prompts_pkey" PRIMARY KEY (id);
 B   ALTER TABLE ONLY public."Prompts" DROP CONSTRAINT "Prompts_pkey";
       public                 xpectro    false    492            �           2606    55690 ,   QueueIntegrations QueueIntegrations_name_key 
   CONSTRAINT     k   ALTER TABLE ONLY public."QueueIntegrations"
    ADD CONSTRAINT "QueueIntegrations_name_key" UNIQUE (name);
 Z   ALTER TABLE ONLY public."QueueIntegrations" DROP CONSTRAINT "QueueIntegrations_name_key";
       public                 xpectro    false    486            �           2606    55688 (   QueueIntegrations QueueIntegrations_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."QueueIntegrations"
    ADD CONSTRAINT "QueueIntegrations_pkey" PRIMARY KEY (id);
 V   ALTER TABLE ONLY public."QueueIntegrations" DROP CONSTRAINT "QueueIntegrations_pkey";
       public                 xpectro    false    486            �           2606    55692 3   QueueIntegrations QueueIntegrations_projectName_key 
   CONSTRAINT     {   ALTER TABLE ONLY public."QueueIntegrations"
    ADD CONSTRAINT "QueueIntegrations_projectName_key" UNIQUE ("projectName");
 a   ALTER TABLE ONLY public."QueueIntegrations" DROP CONSTRAINT "QueueIntegrations_projectName_key";
       public                 xpectro    false    486            �           2606    55327    QueueOptions QueueOptions_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."QueueOptions"
    ADD CONSTRAINT "QueueOptions_pkey" PRIMARY KEY (id);
 L   ALTER TABLE ONLY public."QueueOptions" DROP CONSTRAINT "QueueOptions_pkey";
       public                 xpectro    false    450            u           2606    55316    Queues Queues_color_key 
   CONSTRAINT     d   ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_color_key" UNIQUE (color, "companyId");
 E   ALTER TABLE ONLY public."Queues" DROP CONSTRAINT "Queues_color_key";
       public                 xpectro    false    432    432            w           2606    55318    Queues Queues_name_key 
   CONSTRAINT     b   ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_name_key" UNIQUE (name, "companyId");
 D   ALTER TABLE ONLY public."Queues" DROP CONSTRAINT "Queues_name_key";
       public                 xpectro    false    432    432            y           2606    55119    Queues Queues_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_pkey" PRIMARY KEY (id);
 @   ALTER TABLE ONLY public."Queues" DROP CONSTRAINT "Queues_pkey";
       public                 xpectro    false    432            �           2606    55235     QuickMessages QuickMessages_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."QuickMessages"
    ADD CONSTRAINT "QuickMessages_pkey" PRIMARY KEY (id);
 N   ALTER TABLE ONLY public."QuickMessages" DROP CONSTRAINT "QuickMessages_pkey";
       public                 xpectro    false    442            �           2606    55352    Schedules Schedules_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_pkey" PRIMARY KEY (id);
 F   ALTER TABLE ONLY public."Schedules" DROP CONSTRAINT "Schedules_pkey";
       public                 xpectro    false    452            ]           2606    54979     SequelizeMeta SequelizeMeta_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);
 N   ALTER TABLE ONLY public."SequelizeMeta" DROP CONSTRAINT "SequelizeMeta_pkey";
       public                 xpectro    false    418            �           2606    55619     Subscriptions Subscriptions_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."Subscriptions"
    ADD CONSTRAINT "Subscriptions_pkey" PRIMARY KEY (id);
 N   ALTER TABLE ONLY public."Subscriptions" DROP CONSTRAINT "Subscriptions_pkey";
       public                 xpectro    false    478            �           2606    55386    Tags Tags_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public."Tags"
    ADD CONSTRAINT "Tags_pkey" PRIMARY KEY (id);
 <   ALTER TABLE ONLY public."Tags" DROP CONSTRAINT "Tags_pkey";
       public                 xpectro    false    454            �           2606    55211    TicketNotes TicketNotes_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public."TicketNotes"
    ADD CONSTRAINT "TicketNotes_pkey" PRIMARY KEY (id);
 J   ALTER TABLE ONLY public."TicketNotes" DROP CONSTRAINT "TicketNotes_pkey";
       public                 xpectro    false    440            �           2606    55259     TicketTraking TicketTraking_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_pkey" PRIMARY KEY (id);
 N   ALTER TABLE ONLY public."TicketTraking" DROP CONSTRAINT "TicketTraking_pkey";
       public                 xpectro    false    446            h           2606    55020    Tickets Tickets_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_pkey" PRIMARY KEY (id);
 B   ALTER TABLE ONLY public."Tickets" DROP CONSTRAINT "Tickets_pkey";
       public                 xpectro    false    424            }           2606    55138    UserQueues UserQueues_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."UserQueues"
    ADD CONSTRAINT "UserQueues_pkey" PRIMARY KEY ("userId", "queueId");
 H   ALTER TABLE ONLY public."UserQueues" DROP CONSTRAINT "UserQueues_pkey";
       public                 xpectro    false    434    434            �           2606    55288    UserRatings UserRatings_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public."UserRatings"
    ADD CONSTRAINT "UserRatings_pkey" PRIMARY KEY (id);
 J   ALTER TABLE ONLY public."UserRatings" DROP CONSTRAINT "UserRatings_pkey";
       public                 xpectro    false    448            _           2606    55001    Users Users_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key" UNIQUE (email);
 C   ALTER TABLE ONLY public."Users" DROP CONSTRAINT "Users_email_key";
       public                 xpectro    false    420            a           2606    54999    Users Users_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);
 >   ALTER TABLE ONLY public."Users" DROP CONSTRAINT "Users_pkey";
       public                 xpectro    false    420            {           2606    55133 "   WhatsappQueues WhatsappQueues_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public."WhatsappQueues"
    ADD CONSTRAINT "WhatsappQueues_pkey" PRIMARY KEY ("whatsappId", "queueId");
 P   ALTER TABLE ONLY public."WhatsappQueues" DROP CONSTRAINT "WhatsappQueues_pkey";
       public                 xpectro    false    433    433            o           2606    55084    Whatsapps Whatsapps_name_key 
   CONSTRAINT     [   ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_name_key" UNIQUE (name);
 J   ALTER TABLE ONLY public."Whatsapps" DROP CONSTRAINT "Whatsapps_name_key";
       public                 xpectro    false    427            q           2606    55058    Whatsapps Whatsapps_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_pkey" PRIMARY KEY (id);
 F   ALTER TABLE ONLY public."Whatsapps" DROP CONSTRAINT "Whatsapps_pkey";
       public                 xpectro    false    427            j           2606    55815 "   Tickets contactid_companyid_unique 
   CONSTRAINT     �   ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT contactid_companyid_unique UNIQUE ("contactId", "companyId", "whatsappId");
 N   ALTER TABLE ONLY public."Tickets" DROP CONSTRAINT contactid_companyid_unique;
       public                 xpectro    false    424    424    424            f           2606    55252     Contacts number_companyid_unique 
   CONSTRAINT     l   ALTER TABLE ONLY public."Contacts"
    ADD CONSTRAINT number_companyid_unique UNIQUE (number, "companyId");
 L   ALTER TABLE ONLY public."Contacts" DROP CONSTRAINT number_companyid_unique;
       public                 xpectro    false    422    422            d           1259    55605    idx_cont_company_id    INDEX     Q   CREATE INDEX idx_cont_company_id ON public."Contacts" USING btree ("companyId");
 '   DROP INDEX public.idx_cont_company_id;
       public                 xpectro    false    422            �           1259    55609    idx_cpsh_campaign_id    INDEX     [   CREATE INDEX idx_cpsh_campaign_id ON public."CampaignShipping" USING btree ("campaignId");
 (   DROP INDEX public.idx_cpsh_campaign_id;
       public                 xpectro    false    468            �           1259    55608    idx_ctli_contact_list_id    INDEX     b   CREATE INDEX idx_ctli_contact_list_id ON public."ContactListItems" USING btree ("contactListId");
 ,   DROP INDEX public.idx_ctli_contact_list_id;
       public                 xpectro    false    461            m           1259    55607    idx_ms_company_id_ticket_id    INDEX     e   CREATE INDEX idx_ms_company_id_ticket_id ON public."Messages" USING btree ("companyId", "ticketId");
 /   DROP INDEX public.idx_ms_company_id_ticket_id;
       public                 xpectro    false    425    425            �           1259    55606    idx_sched_company_id    INDEX     S   CREATE INDEX idx_sched_company_id ON public."Schedules" USING btree ("companyId");
 (   DROP INDEX public.idx_sched_company_id;
       public                 xpectro    false    452            �           1259    55604    idx_tg_company_id    INDEX     K   CREATE INDEX idx_tg_company_id ON public."Tags" USING btree ("companyId");
 %   DROP INDEX public.idx_tg_company_id;
       public                 xpectro    false    454            �           2606    55540 *   Announcements Announcements_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Announcements"
    ADD CONSTRAINT "Announcements_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."Announcements" DROP CONSTRAINT "Announcements_companyId_fkey";
       public               xpectro    false    436    3713    470                       2606    55651 )   BaileysChats BaileysChats_whatsappId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."BaileysChats"
    ADD CONSTRAINT "BaileysChats_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 W   ALTER TABLE ONLY public."BaileysChats" DROP CONSTRAINT "BaileysChats_whatsappId_fkey";
       public               xpectro    false    482    3697    427                       2606    55670 2   BaileysMessages BaileysMessages_baileysChatId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."BaileysMessages"
    ADD CONSTRAINT "BaileysMessages_baileysChatId_fkey" FOREIGN KEY ("baileysChatId") REFERENCES public."BaileysChats"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 `   ALTER TABLE ONLY public."BaileysMessages" DROP CONSTRAINT "BaileysMessages_baileysChatId_fkey";
       public               xpectro    false    482    3763    484                       2606    55665 /   BaileysMessages BaileysMessages_whatsappId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."BaileysMessages"
    ADD CONSTRAINT "BaileysMessages_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public."BaileysMessages" DROP CONSTRAINT "BaileysMessages_whatsappId_fkey";
       public               xpectro    false    484    427    3697            �           2606    55491 0   CampaignSettings CampaignSettings_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."CampaignSettings"
    ADD CONSTRAINT "CampaignSettings_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public."CampaignSettings" DROP CONSTRAINT "CampaignSettings_companyId_fkey";
       public               xpectro    false    465    3713    436            �           2606    55517 1   CampaignShipping CampaignShipping_campaignId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."CampaignShipping"
    ADD CONSTRAINT "CampaignShipping_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES public."Campaigns"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 _   ALTER TABLE ONLY public."CampaignShipping" DROP CONSTRAINT "CampaignShipping_campaignId_fkey";
       public               xpectro    false    468    463    3744            �           2606    55512 0   CampaignShipping CampaignShipping_contactId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."CampaignShipping"
    ADD CONSTRAINT "CampaignShipping_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."ContactListItems"(id) ON UPDATE SET NULL ON DELETE SET NULL;
 ^   ALTER TABLE ONLY public."CampaignShipping" DROP CONSTRAINT "CampaignShipping_contactId_fkey";
       public               xpectro    false    461    468    3741            �           2606    55467 "   Campaigns Campaigns_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 P   ALTER TABLE ONLY public."Campaigns" DROP CONSTRAINT "Campaigns_companyId_fkey";
       public               xpectro    false    436    3713    463            �           2606    55472 &   Campaigns Campaigns_contactListId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_contactListId_fkey" FOREIGN KEY ("contactListId") REFERENCES public."ContactLists"(id) ON UPDATE SET NULL ON DELETE SET NULL;
 T   ALTER TABLE ONLY public."Campaigns" DROP CONSTRAINT "Campaigns_contactListId_fkey";
       public               xpectro    false    459    463    3739            �           2606    55785 #   Campaigns Campaigns_fileListId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_fileListId_fkey" FOREIGN KEY ("fileListId") REFERENCES public."Files"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 Q   ALTER TABLE ONLY public."Campaigns" DROP CONSTRAINT "Campaigns_fileListId_fkey";
       public               xpectro    false    488    463    3773            �           2606    55477 #   Campaigns Campaigns_whatsappId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE SET NULL ON DELETE SET NULL;
 Q   ALTER TABLE ONLY public."Campaigns" DROP CONSTRAINT "Campaigns_whatsappId_fkey";
       public               xpectro    false    463    3697    427            �           2606    55594 %   ChatMessages ChatMessages_chatId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."ChatMessages"
    ADD CONSTRAINT "ChatMessages_chatId_fkey" FOREIGN KEY ("chatId") REFERENCES public."Chats"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 S   ALTER TABLE ONLY public."ChatMessages" DROP CONSTRAINT "ChatMessages_chatId_fkey";
       public               xpectro    false    3753    472    476                        2606    55599 '   ChatMessages ChatMessages_senderId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."ChatMessages"
    ADD CONSTRAINT "ChatMessages_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public."ChatMessages" DROP CONSTRAINT "ChatMessages_senderId_fkey";
       public               xpectro    false    420    476    3681            �           2606    55574    ChatUsers ChatUsers_chatId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."ChatUsers"
    ADD CONSTRAINT "ChatUsers_chatId_fkey" FOREIGN KEY ("chatId") REFERENCES public."Chats"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public."ChatUsers" DROP CONSTRAINT "ChatUsers_chatId_fkey";
       public               xpectro    false    3753    474    472            �           2606    55579    ChatUsers ChatUsers_userId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."ChatUsers"
    ADD CONSTRAINT "ChatUsers_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public."ChatUsers" DROP CONSTRAINT "ChatUsers_userId_fkey";
       public               xpectro    false    420    3681    474            �           2606    55561    Chats Chats_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public."Chats" DROP CONSTRAINT "Chats_companyId_fkey";
       public               xpectro    false    3713    472    436            �           2606    55556    Chats Chats_ownerId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public."Chats" DROP CONSTRAINT "Chats_ownerId_fkey";
       public               xpectro    false    420    472    3681            �           2606    55198    Companies Companies_planId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Companies"
    ADD CONSTRAINT "Companies_planId_fkey" FOREIGN KEY ("planId") REFERENCES public."Plans"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 M   ALTER TABLE ONLY public."Companies" DROP CONSTRAINT "Companies_planId_fkey";
       public               xpectro    false    436    438    3717            �           2606    55068 6   ContactCustomFields ContactCustomFields_contactId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."ContactCustomFields"
    ADD CONSTRAINT "ContactCustomFields_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 d   ALTER TABLE ONLY public."ContactCustomFields" DROP CONSTRAINT "ContactCustomFields_contactId_fkey";
       public               xpectro    false    3683    429    422            �           2606    55442 0   ContactListItems ContactListItems_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."ContactListItems"
    ADD CONSTRAINT "ContactListItems_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public."ContactListItems" DROP CONSTRAINT "ContactListItems_companyId_fkey";
       public               xpectro    false    3713    461    436            �           2606    55437 4   ContactListItems ContactListItems_contactListId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."ContactListItems"
    ADD CONSTRAINT "ContactListItems_contactListId_fkey" FOREIGN KEY ("contactListId") REFERENCES public."ContactLists"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 b   ALTER TABLE ONLY public."ContactListItems" DROP CONSTRAINT "ContactListItems_contactListId_fkey";
       public               xpectro    false    461    3739    459            �           2606    55422 (   ContactLists ContactLists_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."ContactLists"
    ADD CONSTRAINT "ContactLists_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 V   ALTER TABLE ONLY public."ContactLists" DROP CONSTRAINT "ContactLists_companyId_fkey";
       public               xpectro    false    459    436    3713            �           2606    55160     Contacts Contacts_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Contacts"
    ADD CONSTRAINT "Contacts_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 N   ALTER TABLE ONLY public."Contacts" DROP CONSTRAINT "Contacts_companyId_fkey";
       public               xpectro    false    422    436    3713            �           2606    55816 !   Contacts Contacts_whatsappId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Contacts"
    ADD CONSTRAINT "Contacts_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 O   ALTER TABLE ONLY public."Contacts" DROP CONSTRAINT "Contacts_whatsappId_fkey";
       public               xpectro    false    427    422    3697                       2606    55727 %   FilesOptions FilesOptions_fileId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."FilesOptions"
    ADD CONSTRAINT "FilesOptions_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Files"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 S   ALTER TABLE ONLY public."FilesOptions" DROP CONSTRAINT "FilesOptions_fileId_fkey";
       public               xpectro    false    490    3773    488                       2606    55713    Files Files_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "Files_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public."Files" DROP CONSTRAINT "Files_companyId_fkey";
       public               xpectro    false    3713    436    488                       2606    55634     Invoices Invoices_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Invoices"
    ADD CONSTRAINT "Invoices_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public."Invoices" DROP CONSTRAINT "Invoices_companyId_fkey";
       public               xpectro    false    3713    436    480            �           2606    55165     Messages Messages_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 N   ALTER TABLE ONLY public."Messages" DROP CONSTRAINT "Messages_companyId_fkey";
       public               xpectro    false    3713    436    425            �           2606    55095     Messages Messages_contactId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public."Messages" DROP CONSTRAINT "Messages_contactId_fkey";
       public               xpectro    false    422    425    3683            �           2606    55522    Messages Messages_queueId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES public."Queues"(id) ON UPDATE SET NULL ON DELETE SET NULL;
 L   ALTER TABLE ONLY public."Messages" DROP CONSTRAINT "Messages_queueId_fkey";
       public               xpectro    false    3705    425    432            �           2606    55106 "   Messages Messages_quotedMsgId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_quotedMsgId_fkey" FOREIGN KEY ("quotedMsgId") REFERENCES public."Messages"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 P   ALTER TABLE ONLY public."Messages" DROP CONSTRAINT "Messages_quotedMsgId_fkey";
       public               xpectro    false    425    425    3692            �           2606    55045    Messages Messages_ticketId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public."Messages" DROP CONSTRAINT "Messages_ticketId_fkey";
       public               xpectro    false    425    3688    424            	           2606    55764    Prompts Prompts_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Prompts"
    ADD CONSTRAINT "Prompts_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id);
 L   ALTER TABLE ONLY public."Prompts" DROP CONSTRAINT "Prompts_companyId_fkey";
       public               xpectro    false    3713    492    436            
           2606    55759    Prompts Prompts_queueId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Prompts"
    ADD CONSTRAINT "Prompts_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES public."Queues"(id);
 J   ALTER TABLE ONLY public."Prompts" DROP CONSTRAINT "Prompts_queueId_fkey";
       public               xpectro    false    3705    492    432                       2606    55699 2   QueueIntegrations QueueIntegrations_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."QueueIntegrations"
    ADD CONSTRAINT "QueueIntegrations_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 `   ALTER TABLE ONLY public."QueueIntegrations" DROP CONSTRAINT "QueueIntegrations_companyId_fkey";
       public               xpectro    false    3713    436    486            �           2606    55333 '   QueueOptions QueueOptions_parentId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."QueueOptions"
    ADD CONSTRAINT "QueueOptions_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."QueueOptions"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public."QueueOptions" DROP CONSTRAINT "QueueOptions_parentId_fkey";
       public               xpectro    false    450    450    3729            �           2606    55328 &   QueueOptions QueueOptions_queueId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."QueueOptions"
    ADD CONSTRAINT "QueueOptions_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES public."Queues"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 T   ALTER TABLE ONLY public."QueueOptions" DROP CONSTRAINT "QueueOptions_queueId_fkey";
       public               xpectro    false    432    3705    450            �           2606    55170    Queues Queues_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 J   ALTER TABLE ONLY public."Queues" DROP CONSTRAINT "Queues_companyId_fkey";
       public               xpectro    false    436    432    3713            �           2606    55775     Queues Queues_integrationId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_integrationId_fkey" FOREIGN KEY ("integrationId") REFERENCES public."QueueIntegrations"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 N   ALTER TABLE ONLY public."Queues" DROP CONSTRAINT "Queues_integrationId_fkey";
       public               xpectro    false    3769    486    432            �           2606    55801    Queues Queues_promptId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_promptId_fkey" FOREIGN KEY ("promptId") REFERENCES public."Prompts"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 I   ALTER TABLE ONLY public."Queues" DROP CONSTRAINT "Queues_promptId_fkey";
       public               xpectro    false    432    3777    492            �           2606    55236 *   QuickMessages QuickMessages_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."QuickMessages"
    ADD CONSTRAINT "QuickMessages_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."QuickMessages" DROP CONSTRAINT "QuickMessages_companyId_fkey";
       public               xpectro    false    436    442    3713            �           2606    55373 '   QuickMessages QuickMessages_userId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."QuickMessages"
    ADD CONSTRAINT "QuickMessages_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public."QuickMessages" DROP CONSTRAINT "QuickMessages_userId_fkey";
       public               xpectro    false    442    420    3681            �           2606    55368 "   Schedules Schedules_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 P   ALTER TABLE ONLY public."Schedules" DROP CONSTRAINT "Schedules_companyId_fkey";
       public               xpectro    false    452    3713    436            �           2606    55353 "   Schedules Schedules_contactId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 P   ALTER TABLE ONLY public."Schedules" DROP CONSTRAINT "Schedules_contactId_fkey";
       public               xpectro    false    3683    452    422            �           2606    55358 !   Schedules Schedules_ticketId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON UPDATE SET NULL ON DELETE SET NULL;
 O   ALTER TABLE ONLY public."Schedules" DROP CONSTRAINT "Schedules_ticketId_fkey";
       public               xpectro    false    452    3688    424            �           2606    55363    Schedules Schedules_userId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE SET NULL ON DELETE SET NULL;
 M   ALTER TABLE ONLY public."Schedules" DROP CONSTRAINT "Schedules_userId_fkey";
       public               xpectro    false    3681    452    420            �           2606    55150     Settings Settings_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Settings"
    ADD CONSTRAINT "Settings_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 N   ALTER TABLE ONLY public."Settings" DROP CONSTRAINT "Settings_companyId_fkey";
       public               xpectro    false    436    3713    430                       2606    55620 *   Subscriptions Subscriptions_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Subscriptions"
    ADD CONSTRAINT "Subscriptions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 X   ALTER TABLE ONLY public."Subscriptions" DROP CONSTRAINT "Subscriptions_companyId_fkey";
       public               xpectro    false    436    3713    478            �           2606    55387    Tags Tags_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Tags"
    ADD CONSTRAINT "Tags_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public."Tags" DROP CONSTRAINT "Tags_companyId_fkey";
       public               xpectro    false    436    3713    454            �           2606    55217 &   TicketNotes TicketNotes_contactId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."TicketNotes"
    ADD CONSTRAINT "TicketNotes_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 T   ALTER TABLE ONLY public."TicketNotes" DROP CONSTRAINT "TicketNotes_contactId_fkey";
       public               xpectro    false    422    440    3683            �           2606    55222 %   TicketNotes TicketNotes_ticketId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."TicketNotes"
    ADD CONSTRAINT "TicketNotes_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 S   ALTER TABLE ONLY public."TicketNotes" DROP CONSTRAINT "TicketNotes_ticketId_fkey";
       public               xpectro    false    440    3688    424            �           2606    55212 #   TicketNotes TicketNotes_userId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."TicketNotes"
    ADD CONSTRAINT "TicketNotes_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 Q   ALTER TABLE ONLY public."TicketNotes" DROP CONSTRAINT "TicketNotes_userId_fkey";
       public               xpectro    false    420    440    3681            �           2606    55400     TicketTags TicketTags_tagId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."TicketTags"
    ADD CONSTRAINT "TicketTags_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES public."Tags"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public."TicketTags" DROP CONSTRAINT "TicketTags_tagId_fkey";
       public               xpectro    false    455    3734    454            �           2606    55395 #   TicketTags TicketTags_ticketId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."TicketTags"
    ADD CONSTRAINT "TicketTags_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public."TicketTags" DROP CONSTRAINT "TicketTags_ticketId_fkey";
       public               xpectro    false    424    3688    455            �           2606    55265 *   TicketTraking TicketTraking_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON DELETE SET NULL;
 X   ALTER TABLE ONLY public."TicketTraking" DROP CONSTRAINT "TicketTraking_companyId_fkey";
       public               xpectro    false    446    436    3713            �           2606    55260 )   TicketTraking TicketTraking_ticketId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON DELETE SET NULL;
 W   ALTER TABLE ONLY public."TicketTraking" DROP CONSTRAINT "TicketTraking_ticketId_fkey";
       public               xpectro    false    3688    446    424            �           2606    55275 '   TicketTraking TicketTraking_userId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON DELETE SET NULL;
 U   ALTER TABLE ONLY public."TicketTraking" DROP CONSTRAINT "TicketTraking_userId_fkey";
       public               xpectro    false    420    446    3681            �           2606    55270 +   TicketTraking TicketTraking_whatsappId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON DELETE SET NULL;
 Y   ALTER TABLE ONLY public."TicketTraking" DROP CONSTRAINT "TicketTraking_whatsappId_fkey";
       public               xpectro    false    3697    427    446            �           2606    55180    Tickets Tickets_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 L   ALTER TABLE ONLY public."Tickets" DROP CONSTRAINT "Tickets_companyId_fkey";
       public               xpectro    false    424    436    3713            �           2606    55021    Tickets Tickets_contactId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;
 L   ALTER TABLE ONLY public."Tickets" DROP CONSTRAINT "Tickets_contactId_fkey";
       public               xpectro    false    422    3683    424            �           2606    55739 "   Tickets Tickets_integrationId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_integrationId_fkey" FOREIGN KEY ("integrationId") REFERENCES public."QueueIntegrations"(id);
 P   ALTER TABLE ONLY public."Tickets" DROP CONSTRAINT "Tickets_integrationId_fkey";
       public               xpectro    false    3769    486    424            �           2606    55124    Tickets Tickets_queueId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES public."Queues"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 J   ALTER TABLE ONLY public."Tickets" DROP CONSTRAINT "Tickets_queueId_fkey";
       public               xpectro    false    432    424    3705            �           2606    55338 "   Tickets Tickets_queueOptionId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_queueOptionId_fkey" FOREIGN KEY ("queueOptionId") REFERENCES public."QueueOptions"(id) ON UPDATE SET NULL ON DELETE SET NULL;
 P   ALTER TABLE ONLY public."Tickets" DROP CONSTRAINT "Tickets_queueOptionId_fkey";
       public               xpectro    false    424    3729    450            �           2606    55026    Tickets Tickets_userId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 I   ALTER TABLE ONLY public."Tickets" DROP CONSTRAINT "Tickets_userId_fkey";
       public               xpectro    false    3681    424    420            �           2606    55086    Tickets Tickets_whatsappId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 M   ALTER TABLE ONLY public."Tickets" DROP CONSTRAINT "Tickets_whatsappId_fkey";
       public               xpectro    false    424    3697    427            �           2606    55294 &   UserRatings UserRatings_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."UserRatings"
    ADD CONSTRAINT "UserRatings_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON DELETE SET NULL;
 T   ALTER TABLE ONLY public."UserRatings" DROP CONSTRAINT "UserRatings_companyId_fkey";
       public               xpectro    false    436    448    3713            �           2606    55289 %   UserRatings UserRatings_ticketId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."UserRatings"
    ADD CONSTRAINT "UserRatings_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON DELETE SET NULL;
 S   ALTER TABLE ONLY public."UserRatings" DROP CONSTRAINT "UserRatings_ticketId_fkey";
       public               xpectro    false    448    3688    424            �           2606    55299 #   UserRatings UserRatings_userId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."UserRatings"
    ADD CONSTRAINT "UserRatings_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON DELETE SET NULL;
 Q   ALTER TABLE ONLY public."UserRatings" DROP CONSTRAINT "UserRatings_userId_fkey";
       public               xpectro    false    3681    420    448            �           2606    55155    Users Users_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 H   ALTER TABLE ONLY public."Users" DROP CONSTRAINT "Users_companyId_fkey";
       public               xpectro    false    436    3713    420            �           2606    55694    Users Users_whatsappId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 I   ALTER TABLE ONLY public."Users" DROP CONSTRAINT "Users_whatsappId_fkey";
       public               xpectro    false    3697    420    427            �           2606    55175 "   Whatsapps Whatsapps_companyId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 P   ALTER TABLE ONLY public."Whatsapps" DROP CONSTRAINT "Whatsapps_companyId_fkey";
       public               xpectro    false    3713    436    427            �           2606    55780 &   Whatsapps Whatsapps_integrationId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_integrationId_fkey" FOREIGN KEY ("integrationId") REFERENCES public."QueueIntegrations"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 T   ALTER TABLE ONLY public."Whatsapps" DROP CONSTRAINT "Whatsapps_integrationId_fkey";
       public               xpectro    false    486    3769    427            �           2606    55769 !   Whatsapps Whatsapps_promptId_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_promptId_fkey" FOREIGN KEY ("promptId") REFERENCES public."Prompts"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
 O   ALTER TABLE ONLY public."Whatsapps" DROP CONSTRAINT "Whatsapps_promptId_fkey";
       public               xpectro    false    427    3777    492            �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �      x�m��N�@@��Wp7������&Mj��D= 4J"l��Ij�=�73/��)Y��]�P�1���ѵ�!�:��u�p5/# � Z���,��� �8!���Bp#���=��1�A�0ZVHnH��G��!�o�񣿌�ts���0��,o��õ���Ϋϱ����q���U@g9�q)G�]�\]�S�%�M��S��Z�������6/*�D�{+�	���bh�pM�,kBڪ�Cp�j>�p��~ h�b}      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   Z   x�3��I�Sp,K̫JL���/H��440�4202�50�52P04�21�24�&B�"��������D���
$�eD}+�b�V��P+��b���� ?�+2      �   
   x������ � �      �   g   x�3��I�Sp,K̫JL��440@�FF��F��
VF@d�gj`��_�r���WpJ,�LYEf3,����@f���`1����D����1z\\\ ��)i      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   �  x��X�r�6��+�ta!��ё�DI�$��K�\���f���Oc���ɥ2��ݯ� �P�sLiJqª*���Jz!�������q�L�d|��i�"��N��\ �C��>>� Ç4s���N|��!~�o�L
6�P���ly��8	ٷ�]͛j�'�ټeuc ��7l�g��<y�5NH���f���n�=�׼LS�(�[�6XL1N	=$�{֝����	�ր�T��v�|���e��cW7�/�U"JpV��9Ip)��#Rd�^�c�>�sw;`�"�*~ǦF'n����{K]���$Ř$�P�Ӻ-�yz[p�[)ډ�`E��N�x�.y�e�����4�i��+���
�S�5� ��@B�����OC�����i�O��/�Jq��%��W�L0�,�F_�l�.��+
ϊ�P��b���k.��������/S�Ҋ�ƺ�B���Z�4k�j<��N�_&>��������Ն�0O!E|r�bcx1��T��Cu��p d�a#��ȹJ9���D	�4Բv`�v-�m�KgV$:N�h컶	�C<�?jK�Y�.���mb�K��$���?u��i���q��a�]�Q����

��@4^\��l���dr	�D�y55&'��g�7� �֨(w ����[�;�3Mfr�'����~��Ŋ;��]������Ԇm�&��K�{�+?PdkS
�
��#�;�tP�~��nFv|�$�A��Ӻ����Sp���� �Tđ�j��
'RZ�g��3�=�{j;�
\�ւa&ݨ��2�C�U��ɉ���xE|��L%ң���8 &(�hEI?�$�`��#�P�m/7��1+W�!?�����0>���Z�+���f�UT��a��Kv�`�Z�����`�
29a+l�>+�@cwC��7�4�*R?X3r7�~�+H�]\ag���o��E!@s��"Ԯ=�m$����܇�侅+ ����V�?j!�aqX���������sɠԧn�.���B�g.���{=�?u���ɯ_C�)09�Wb�F�َ`StXӪ����\w�������q��q�dB5�t=ʛn�������"����*�����<w�	�_y2y�u������d���Re�
�נ��E3 ��v�8��٢W�� ~11݊�X�*j�ys��k_����)��U�>0y��UN;	�w�J�	|ɀJx�c^t�_Ö���^,|wG�:RW_�������}��k^
�SЫ�@U���^{5΁�%�i�Ŭ�)iT?�ҵ�e�� Tpu���qS��auPŅP����աO#����eLc�xw�eV�I�_����)��-��tS��c\�/�{Ȝ��k�3��xXiZ��[��䳚�W�On�.��\Uf�u?Uh(`����uI�=�٦�(����P��;>���q�&��jl*�7LY&��P?��x&=��ܼ��ƚ�yEJ�0
��r�G�N�ZCG;� x��� @�X�
9��q�<�J�A�u8)HaV�4��*Lz<�B�wP��"+�V���.?
0�}U~��ڢZI�*��r�����&��"�-
`
�F��"������jF���kЍq�:�X�Dt��kްG'�s�7C������
���G�dG��Lpn�����ܺP9�g����8���M-�T��7���.��;M��x��l��Gr�0��;t⎏~��s��KK5#����+ި�|��������d      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   �  x�}ZI�7<k^�w�n��@g��	X�"�	�E4�%���~�����p��;�o�/����z*ퟜR�E5��I8�%u��A��������
�=�Tf�ڕ�bE�z���k�J�DO~T Q4/��K��l�}��[2���N�R �	�L� ��f�d�Kr���Y�6�[�sJ��Z�C��E�O��ת9�6�����TrV_.��)����䠾C�?U?����4L9��'��
%anW��s�
僦���+s���!Z����b�Z��t�M�_�gXa�PS9kZ�%1c8�5j5SG:x�A �ǚ��#r�Lc������Aj3}X}\��wO!��Ɯ��)|��r���!w�B���b�(W�d�B�q��+�Iը���4���H�M�NS'eH)!w�j�����r��벇@茅�W=fɘ�p��jzd-��*-$���Ǿ����Rb�/�^>�ӶBQ�RO��}�����Zu0��������B�s���	!��2�T�ra���Mc:�/ca�R�Gw�z�ƭ�z#/�)��� g��#W�d�4\�"��?U
p%�:��	b�����&�i���� �ZcO��^�ᬩ�/|��_�Qi�����A�ѱP^M=����Ax�8�饳��N�Y�wO!�׏�O^JD�7څ��i�C����iF�T%H�'Bˉ�Tk�%�A ��׿���Z	�����Q�I�Z�nC��ʾ�ԆA��͉��㌒����ҽ�wC?I��Z�>}�z*�}�D�-܀NB��G��4Z1����`����D�lu^���Cx�X�j��J�-�\|69�Ɓ��C�osnB����1l�R"��!�ZS���&_JBG�>kj�y��`�A���W��.�ە �6==�Z��;�>&��ڧmQ�#�BR1�U���S�ѷ|Bڋ��b#��Ǵ��~}�0�DuւȘ��
BMcG�.�F#�����Ek���- �z���)�+�<�4<p]�,�4�k�V��~G�᧬0�;�bQ��7o�:�z����;.�*h�P��Pm�7��T`+�@�L��,�߯i7�`�W����rX��:����6v���k�5�Zp���u�k3
�����m�~o:p���em>����-��s��}0��
Z�l�
�A{3������ƾo������R׾WJ�B�)�|�� ͒�D�[)�:Գ�^Jh�a���8+��j��Q��B�C���bS�����\���c��e��f�/����y�ջd��" ����5�� x+pV�؞k^���Y�`ع8�ұ�Uҷ]e��_�SʂD�Y�<�?l!�jgkP��P>~3@x���O}�V���� 	� �U;~b�$���A��&YsX+�,>�<�z����e�:ů�=��wz}���X���!���#S�
����3?Bx���\���k�C��0Or<R4ە�Ш�R���QO�2f9��;Q��� ���z{�g��S��3���b?����k�\�.]���A�c�_W$��k��.:+|��Eg��-��㓢�g����o��>�}�����ZGR�N�A}��x=��<�l2Z̼�E+�
ٍ�P�0��f�?s@�fI~�3�����������{�ƧbaR�B�^��y�a�� ��X(�A+٣P��׎5vZ�i��dz��ѫ'ٚ�ƽ"{fbFӳ�`�� �'}}}���&�      �   
   x������ � �      �   
   x������ � �      �   
   x������ � �      �   �  x�}�Ko�@���)X�k��� V���_M7S�D�ъ���I�%�7�9���������ʗV�����!��8�˪`A,�A!^VVr R��%�zw��j�,je����f�>�ͼ�eD���_*:D~!���M��RQ�������aCª�oMl�z���囃 Q�z
K�r9z�]ۡh��K#��J��������Ǒ(���[�����ml��:�1o�t�r:ԗ�#�2��x�O揳f���p!
���FIt^����J�}0�*�цMl�nR*��֖���1�+��ҘA�P)rQT����AU����÷�n���ha��O�dg�z��ƶU��M��Υ:[aтo��(�c]"��$X�i�M{�%LMz�����U����N��	�C��      �   
   x������ � �      �   
   x������ � �     